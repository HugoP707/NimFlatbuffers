import math, sugar
import good_table
export good_table


const MAX_BUFFER_SIZE* = 2^31


type Builder* = object of RootObj
  bytes*: seq[byte]
  minalign*: int
  current_vtable*: seq[uoffset]
  objectEnd*: uoffset
  vtables*: seq[uoffset] #?
  head*: uoffset
  nested*: bool
  finished*: bool

func newBuilder*(size: int): Builder =
  result.bytes.setLen(size)
  result.minalign = 1
  result.head = size.uoffset
  result.vtables = newSeq[uoffset](16)
  result.nested = false
  result.finished = false


using self: var Builder

proc output*(self): seq[byte] =
  if not self.finished:
    quit("Builder not finished")

  return self.bytes[self.head..^1]

func offset*(self): uoffset =
  result = self.bytes.len.uoffset - self.head

proc startObject*(self; numfields: int) =
  if self.nested:
    quit("builder is nested")
  self.current_vtable = collect(newSeq):  #Generator with some sugar
    for _ in 0..numfields: 0.uoffset

  self.objectEnd = self.offset()
  self.nested = true

proc growByteBuffer*(self) =
  if self.bytes.len == MAX_BUFFER_SIZE:
    quit("flatbuffers: cannot grow buffer beyond 2 gigabytes")
  var newSize = min(self.bytes.len * 2, MAX_BUFFER_SIZE)
  if newSize == 0:
    newSize = 1
  var bytes2: seq[byte]
  bytes2.setLen newSize
  bytes2[newSize-self.bytes.len..^1] = self.bytes
  self.bytes = bytes2

proc Place*[T](self; x: T) =
  self.head -= x.sizeof.uoffset
  WriteVal(self.bytes.toOpenArray(self.head.int, self.bytes.len - 1), x)

func Pad*(self; n: int) =
  for i in 0..n:
    self.Place(0)

proc Prep*(self; size: int, additionalBytes: int) =
  if size > self.minalign:
    self.minalign = size
  var alignsize = (not self.bytes.len - self.head.int + additionalBytes) + 1
  alignsize = alignsize and size - 1

  while self.head.int < alignsize + size + additionalBytes:
    let oldbufSize = self.bytes.len
    self.growByteBuffer()
    let update_head = self.head + (self.bytes.len - oldbufSize).uoffset
    self.head = update_head
  self.Pad(alignsize)

proc PrependOffsetRelative*[T: Offsets](self; off: T) =
  self.Prep(T.sizeof, 0)
  if not off <= self.offset.T:
    quit("flatbuffers: Offset arithmetic error.")

  let off2: T = self.offset.T - off + sizeof(T).T
  self.Place(off2)

proc Add*[T](self; n: T) =
  self.Prep(T.sizeof, 0)
  WriteVal(self.bytes.toOpenArray(self.head.int, self.bytes.len - 1), n)

proc vtableEqual*(a: seq[uoffset], objectStart: uoffset, b: seq[byte]): bool =
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

proc writeVtable*(self): uoffset =
  self.PrependOffsetRelative(0.soffset)

  let objectOffset = self.offset
  var existingVtable = 0.uoffset

  var i = self.current_vtable.len - 1
  while i >= 0 and self.vtables[i] == 0: dec i

  self.current_vtable = self.vtables[0..i + 1]

  for i in countdown(self.vtables.len, 0):
    let
      vt2Offset = self.vtables[i]
      vt2Start = self.bytes.len - vt2Offset.int
      vt2Len = GetVal[voffset](self.bytes[vt2Start..^1])

    let
      metadata = 2 * voffset.sizeof # VtableMetadataFields * SizeVOffsetT
      vt2End = vt2Start + vt2Len.int
      vt2 = self.bytes[vt2Start + metadata..vt2End]

    if vtableEqual(self.current_vtable, objectOffset, vt2):
      existingVtable = vt2Offset
      break

  if existingVtable == 0:
    for i in countdown(self.current_vtable.len, 0):
      var off: uoffset
      if self.current_vtable[i] != 0:
        off = objectOffset - self.current_vtable[i]

      self.PrependOffsetRelative(off.voffset)

    let objectSize = objectOffset - self.objectEnd
    self.PrependOffsetRelative(objectSize.voffset)

    let vBytes = (self.current_vtable.len + 2) * voffset.sizeof
    self.PrependOffsetRelative(vBytes.voffset)

    let objectStart = self.bytes.len.soffset - objectOffset.soffset
    WriteVal(self.bytes.toOpenArray(objectStart.int, self.bytes.len - 1),
      (existingVtable - objectOffset).soffset)
      
    self.vtables.add self.offset

  else:
    let objectStart = self.bytes.len.soffset - objectOffset.soffset
    self.head = objectStart.uoffset

    WriteVal(self.bytes.toOpenArray(self.head.int, self.bytes.len - 1),
      (existingVtable - objectOffset).soffset)
    
    self.current_vtable = @[]

    return objectOffset

proc EndObject*(self): uoffset =
  if not self.nested:
    quit("builder is not nested")
  result = self.writeVtable()
  self.nested = false
  
proc StartVector*(self; elemSize: int, numElems: int, alignment: int): uoffset =
  if self.nested:
    quit("builder is nested")
  self.nested = true
  self.Prep(sizeof(uint32), elemSize * numElems)
  self.Prep(alignment, elemSize * numElems)
  return self.offset

proc EndVector*(self; vectorNumElems: int): uoffset =
  if not self.nested:
    quit("builder is not nested")
  self.nested = false
  self.Place(vectorNumElems)
  result = self.offset

proc Create*(self; s: string | seq[byte]): uoffset = #Both CreateString and CreateByeVector functionality
  if self.nested:
    quit("builder is nested")
  self.nested = true

  self.Prep(uoffset.sizeof, s.len + 1 * byte.sizeof)
  self.Place(0.byte)

  let l = s.len.uoffset

  self.head -= l
  if s.typeof == string:
    shallowCopy(self.bytes[self.head.int..self.head.int + 1], cast[seq[byte]](s))
  else:
    shallowCopy(self.bytes[self.head.int..self.head.int + 1], s)
  return self.EndVector(s.len)

proc Slot*(self; slotnum: int) =
  self.current_vtable[slotnum] = self.offset

proc Finish*(self; rootTable: uoffset) =
  if self.nested:
    quit("builder is nested")
  self.nested = true

  self.Prep(self.minalign, uoffset.sizeof)
  self.PrependOffsetRelative(rootTable)
  self.finished = true

proc Prepend*[T](self; x: T) =
  self.Prep(x.sizeof, 0)
  self.Place(x)