import endian


type
  uoffset* = uint32           ## offset in to the buffer
  soffset* = int32            ## offset from start of table, to a vtable
  voffset* = int16            ## offset from start of table to value

type Offsets* = uoffset | soffset | voffset
type Something* = SomeInteger | bool
type Vtable* = object
  Bytes*: seq[byte]
  Pos*: uoffset


func GetVal*[T](b: seq[byte]): T {.inline.} =
  when T is float64:
    return  cast[T](GetVal[uint64](b))
  elif T is float32:
    return cast[T](GetVal[uint32](b))
  elif T is string:
    return cast[T](b[0])
  else:
    return cast[ptr T](unsafeAddr b[0])[]

func Get*(t: var Vtable, off: Offsets, T: typedesc): T =
  result = GetVal[T](t.Bytes[off..^1])

func WriteVal*[T: Something](b: var openArray[byte], n: T) {.inline.} =
  let _ = b[sizeof(T) - 1] # force some range checks
  when sizeof(T) == 8:
    littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
  elif sizeof(T) == 4:
    littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
  elif sizeof(T) == 2:
    littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
  elif sizeof(T) == 1:
    b[0] = n.uint8
  else:
    #littleEndianX(addr b[0], unsafeAddr n, T.sizeof)
    {.error: "Unsupported type".}

func WriteVal*[T: SomeFloat](b: var openArray[byte], n: T) {.inline.} =
  when T is float64:
    WriteVal(b, cast[uint64](n))
  elif T is float32:
    WriteVal(b, cast[uint32](n))

func Offset*(t: var Vtable, off: voffset): voffset =
  let vtable: voffset = (t.Pos - t.Get(t.Pos, uoffset)).voffset
  let vtableEnd: voffset = t.Get(vtable, voffset)
  if off < vtableEnd:
    return t.Get(vtable + off, voffset)
  return 0

proc Mutate*[T](t: var VTable, off: uoffset, n: T): bool =
  WriteVal(t.Bytes.toOpenArray(off.int, t.Bytes.len - 1), n)
  return true

func MutateSlot*[T](t: var Vtable, slot: voffset, n: T): bool =
  let off: voffset = t.Offset(slot)
  if off != 0:
    discard t.Mutate(t.Pos + off.uoffset, n)
    return true
  return false

func Indirect*(t: var Vtable, off: uoffset): uoffset =
  result = off + t.Get(off, uoffset)

func ByteVector*(t: var Vtable, off: uoffset): seq[byte] =
  let newoff: uoffset = off + t.Get(off, uoffset)
  let start = newoff + (uoffset.sizeof).uoffset
  let length = t.Get(off, uoffset)
  return t.Bytes[start..start+length]

func toString*(t: var Vtable, off: uoffset): string =
  result = GetVal[string](t.ByteVector(off))

func VectorLen*(t: var Vtable, off: uoffset): int =
  var newoff: uoffset = off + t.Pos
  newoff += t.Get(off, uoffset)
  return t.Get(newoff, uoffset).int

func Vector*(t: var Vtable, off: uoffset): uoffset =
  let newoff: uoffset = off + t.Get(off, uoffset)
  var x = newoff + t.Get(off, uoffset)
  x += (uoffset.sizeof).uoffset
  return x

func Union*(t: var Vtable, t2: var Vtable, off: uoffset) =
  let newoff: uoffset = off + t.Get(off, uoffset)
  t2.Pos = newoff + t.Get(off, uoffset)
  t2.Bytes = t.Bytes

func GetSlot*[T](t: var Vtable, slot: voffset, d: T): T =
  let off = t.Offset(slot)
  if off == 0:
    return d
  return t.Get(t.Pos + off, T)

func GetOffsetSlot*[T: Offsets](t: var Vtable, slot: voffset, d: T): T =
  let off = t.Offset(slot)
  if off == 0:
    return d
  return off