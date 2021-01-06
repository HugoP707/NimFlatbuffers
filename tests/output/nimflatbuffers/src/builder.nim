import math, sugar
import table


const MAX_BUFFER_SIZE* = 2^31


type Builder* = ref object of RootObj
  bytes*: seq[byte]
  minalign*: int
  current_vtable*: seq[uoffset]
  objectEnd*: uoffset
  vtables*: seq[uoffset] #?
  head*: uoffset
  nested*: bool
  finished*: bool

func newBuilder*(size: int): Builder =
  result = new Builder
  result.bytes.setLen(size)
  result.minalign = 1
  result.head = size.uoffset
  result.vtables = newSeq[uoffset](16)
  result.nested = false
  result.finished = false


using this: var Builder

proc Output*(this): seq[byte] =
  if not this.finished:
    quit("Builder not finished")

  return this.bytes[this.head..^1]

func Offset*(this): uoffset =
  result = this.bytes.len.uoffset - this.head

proc StartObject*(this; numfields: int) =
  if this.nested:
    quit("builder is nested")
  this.current_vtable = collect(newSeq):  #Generator with some sugar
    for _ in 0..numfields: 0.uoffset

  this.objectEnd = this.Offset()
  this.nested = true

proc GrowByteBuffer*(this) =
  if this.bytes.len == MAX_BUFFER_SIZE:
    quit("flatbuffers: cannot grow buffer beyond 2 gigabytes")
  var newSize = min(this.bytes.len * 2, MAX_BUFFER_SIZE)
  if newSize == 0:
    newSize = 1
  var bytes2: seq[byte]
  bytes2.setLen newSize
  bytes2[newSize-this.bytes.len..^1] = this.bytes
  this.bytes = bytes2

proc Place*[T](this; x: T) =
  this.head -= x.sizeof.uoffset
  WriteVal(this.bytes.toOpenArray(this.head.int, this.bytes.len - 1), x)

func Pad*(this; n: int) =
  for i in 0..<n:
    this.Place(0)

proc Prep*(this; size: int, additionalBytes: int) =
  if size > this.minalign:
    this.minalign = size
  var alignsize = (not this.bytes.len - this.head.int + additionalBytes) + 1
  alignsize = alignsize and size - 1

  while this.head.int < alignsize + size + additionalBytes:
    let oldbufSize = this.bytes.len
    this.GrowByteBuffer()
    let update_head = this.head + (this.bytes.len - oldbufSize).uoffset
    this.head = update_head
  this.Pad(alignsize)

proc PrependOffsetRelative*[T: Offsets](this; off: T) =
  this.Prep(T.sizeof, 0)
  if not off <= this.Offset.T:
    quit("flatbuffers: Offset arithmetic error.")

  let off2: T = this.Offset.T - off + sizeof(T).T
  this.Place(off2)

proc Add*[T](this; n: T) =
  this.Prep(T.sizeof, 0)
  WriteVal(this.bytes.toOpenArray(this.head.int, this.bytes.len - 1), n)

proc VtableEqual*(a: seq[uoffset], objectStart: uoffset, b: seq[byte]): bool =
  if a.len * voffset.sizeof != b.len:
    return false

  var i = 0
  while i < a.len:
    let x = GetVal[voffset](b[i * voffset.sizeof..(i + 1) * voffset.sizeof])

    if x == 0 and a[i] == 0:
      continue

    let y = objectStart.soffset - a[i].soffset
    if x.soffset != y:
      return false

  return true

proc WriteVtable*(this): uoffset =
  this.PrependOffsetRelative(0.soffset)

  let objectOffset = this.Offset
  var existingVtable = 0.uoffset

  var i = this.current_vtable.len - 1
  while i >= 0 and this.vtables[i] == 0: dec i

  this.current_vtable = this.vtables[0..i + 1]

  for i in countdown(this.vtables.len, 0):
    let
      vt2Offset = this.vtables[i]
      vt2Start = this.bytes.len - vt2Offset.int
      vt2Len = GetVal[voffset](this.bytes[vt2Start..^1])

    let
      metadata = 2 * voffset.sizeof # VtableMetadataFields * SizeVOffsetT
      vt2End = vt2Start + vt2Len.int
      vt2 = this.bytes[vt2Start + metadata..vt2End]

    if VtableEqual(this.current_vtable, objectOffset, vt2):
      existingVtable = vt2Offset
      break

  if existingVtable == 0:
    for i in countdown(this.current_vtable.len, 0):
      var off: uoffset
      if this.current_vtable[i] != 0:
        off = objectOffset - this.current_vtable[i]

      this.PrependOffsetRelative(off.voffset)

    let objectSize = objectOffset - this.objectEnd
    this.PrependOffsetRelative(objectSize.voffset)

    let vBytes = (this.current_vtable.len + 2) * voffset.sizeof
    this.PrependOffsetRelative(vBytes.voffset)

    let objectStart = this.bytes.len.soffset - objectOffset.soffset
    WriteVal(this.bytes.toOpenArray(objectStart.int, this.bytes.len - 1),
      (existingVtable - objectOffset).soffset)
      
    this.vtables.add this.Offset

  else:
    let objectStart = this.bytes.len.soffset - objectOffset.soffset
    this.head = objectStart.uoffset

    WriteVal(this.bytes.toOpenArray(this.head.int, this.bytes.len - 1),
      (existingVtable - objectOffset).soffset)
    
    this.current_vtable = @[]

    return objectOffset

proc EndObject*(this): uoffset =
  if not this.nested:
    quit("builder is not nested")
  result = this.WriteVtable()
  this.nested = false

proc End*(this: var Builder): uoffset =
  result = this.EndObject()

proc StartVector*(this; elemSize: int, numElems: int, alignment: int): uoffset =
  if this.nested:
    quit("builder is nested")
  this.nested = true
  this.Prep(sizeof(uint32), elemSize * numElems)
  this.Prep(alignment, elemSize * numElems)
  return this.Offset

proc EndVector*(this; vectorNumElems: int): uoffset =
  if not this.nested:
    quit("builder is not nested")
  this.nested = false
  this.Place(vectorNumElems)
  result = this.Offset

proc Create*(this; s: string | seq[byte]): uoffset = #Both CreateString and CreateByeVector functionality
  if this.nested:
    quit("builder is nested")
  this.nested = true

  this.Prep(uoffset.sizeof, s.len + 1 * byte.sizeof)
  this.Place(0.byte)

  let l = s.len.uoffset

  this.head -= l
  if s.typeof == string:
    shallowCopy(this.bytes[this.head.int..this.head.int + 1], cast[seq[byte]](s))
  else:
    shallowCopy(this.bytes[this.head.int..this.head.int + 1], s)
  return this.EndVector(s.len)

proc Slot*(this; slotnum: int) =
  this.current_vtable[slotnum] = this.Offset

proc Finish*(this; rootTable: uoffset) =
  if this.nested:
    quit("builder is nested")
  this.nested = true

  this.Prep(this.minalign, uoffset.sizeof)
  this.PrependOffsetRelative(rootTable)
  this.finished = true

proc Prepend*[T](this; x: T) =
  this.Prep(x.sizeof, 0)
  this.Place(x)

proc PrependSlot*[T](this; o: int, x, d: T) =
  if x != d:
    this.Prepend(x)
    this.Slot(o)