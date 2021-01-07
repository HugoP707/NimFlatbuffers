import endian


type
  uoffset* = uint32           ## offset in to the buffer
  soffset* = int32            ## offset from start of table, to a vtable
  voffset* = int16            ## offset from start of table to value

type Offsets* = uoffset | soffset | voffset

type Vtable* = object
  Bytes*: seq[byte]
  Pos*: uoffset


using this: var Vtable


func GetVal*[T](b: seq[byte]): T {.inline.} =
  when T is float64:
    return  cast[T](GetVal[uint64](b))
  elif T is float32:
    return cast[T](GetVal[uint32](b))
  elif T is string:
    return cast[T](b[0])
  else:
    return cast[ptr T](unsafeAddr b[0])[]

func Get*[T](this; off: uoffset): T =
  result = GetVal[T](this.Bytes[off..^1])

func Get*[T](this; off: soffset): T =
  result = GetVal[T](this.Bytes[off..^1])

func Get*[T](this; off: voffset): T =
  result = GetVal[T](this.Bytes[off..^1])

func WriteVal*[T: not SomeFloat](b: var openArray[byte], n: T) {.inline.} =
  let _ = b[sizeof(T) - 1] # force some range checks
  debugEcho(n)
  debugEcho(n.sizeof)
  when sizeof(T) == 8:
    littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
  elif sizeof(T) == 4:
    littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
  elif sizeof(T) == 2:
    littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
  elif sizeof(T) == 1:
    b[0] = n.uint8
  else:
    discard
    #littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
    #{.error:"shouldnt appear".}

func WriteVal*[T: SomeFloat](b: var openArray[byte], n: T) {.inline.} =
  when T is float64:
    WriteVal(b, cast[uint64](n))
  elif T is float32:
    WriteVal(b, cast[uint32](n))

func Offset*(this; off: voffset): voffset =
  let vtable: voffset = (this.Pos - this.Get[:uoffset](this.Pos)).voffset
  let vtableEnd: voffset = this.Get[:voffset](vtable)
  if off < vtableEnd:
    return this.Get[:voffset](vtable + off)
  return 0

proc Mutate*[T](this; off: uoffset, n: T): bool =
  WriteVal(this.Bytes.toOpenArray(off.int, this.Bytes.len - 1), n)
  return true

func MutateSlot*[T](this; slot: voffset, n: T): bool =
  let off: voffset = this.Offset(slot)
  if off != 0:
    discard this.Mutate(this.Pos + off.uoffset, n)
    return true
  return false

func Indirect*(this; off: uoffset): uoffset =
  result = off + this.Get[:uoffset](off)

func ByteVector*(this; off: uoffset): seq[byte] =
  let
    newoff: uoffset = off + GetVal[uoffset](this.Bytes[off..^1])
    start = newoff + (uoffset.sizeof).uoffset
    length = GetVal[uoffset](this.Bytes[newoff..^1])
  return this.Bytes[start..start+length]

func toString*(this; off: uoffset): string =
  result = GetVal[string](this.ByteVector(off))

func VectorLen*(this; off: uoffset): int =
  var newoff: uoffset = off + this.Pos
  newoff += this.Get[:uoffset](off)
  return this.Get[:uoffset](newoff).int

func Vector*(this; off: uoffset): uoffset =
  let newoff: uoffset = off + this.Get[:uoffset](off)
  var x = newoff + this.Get[:uoffset](off)
  x += (uoffset.sizeof).uoffset
  return x

func Union*(this; t2: var Vtable, off: uoffset) =
  let newoff: uoffset = off + this.Get[:uoffset](off)
  t2.Pos = newoff + this.Get[:uoffset](off)
  t2.Bytes = this.Bytes

func GetSlot*[T](this; slot: voffset, d: T): T =
  let off = this.Offset(slot)
  if off == 0:
    return d
  return this.Get[T](this.Pos + off)

func GetOffsetSlot*[T: Offsets](this; slot: voffset, d: T): T =
  let off = this.Offset(slot)
  if off == 0:
    return d
  return off
