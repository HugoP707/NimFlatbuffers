import endians


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
    return GetVal[uint64](b)
  elif T is float32:
    return GetVal[uint32](b)
  elif T is string:
    return cast[T](b[0])
  else:
    return cast[ptr T](unsafeAddr b[0])[] 

func Get*(t: Vtable, off: Offsets, T: typedesc): T =
  result = GetVal[T](t.Bytes[off..^1])


func WriteVal*[T: Something](b: var openArray[byte], n: T) {.inline.} =
  let _ = b[sizeof(T) - 1] # force some range checks
  when sizeof(T) == 8:
    littleEndian64(addr b[0], unsafeAddr n)
  elif sizeof(T) == 4:
    littleEndian32(addr b[0], unsafeAddr n)
  elif sizeof(T) == 2:
    littleEndian16(addr b[0], unsafeAddr n)
  elif sizeof(T) == 1:
    b[0] = n.uint8
  else:
    {.error: "Unsupported integer type".}

func WriteVal*[T: SomeFloat](b: var openArray[byte], n: T) {.inline.} =
  when T is float64:
    WriteVal(b, cast[uint64](n))
  elif T is float32:
    WriteVal(b, cast[uint32](n))
  else:
    {.error: "Unsupported float type".}
  
func Mutate*[T](t: var VTable, off: voffset, n: T): bool =
  WriteVal(t.Bytes.toOpenArray(off.int, t.Bytes.len - 1), n)
  return true

func Offset*(t: Vtable, off: voffset): voffset =
  let vtable: voffset = (t.Pos - t.Get(t.Pos, uoffset)).voffset
  let vtableEnd: voffset = t.Get(vtable, voffset)
  if off < vtableEnd:
    return t.Get(vtable + off, voffset)
  return 0

func Indirect*(t: Vtable, off: uoffset): uoffset =
  result = off + t.Get(off, uoffset)

func ByteVector*(t: Vtable, off: uoffset): seq[byte] =
  let newoff: uoffset = off + t.Get(off, uoffset)
  let start = newoff + (uoffset.sizeof).uoffset
  let length = t.Get(off, uoffset)
  return t.Bytes[start..start+length]

func toString*(t: Vtable, off: uoffset): string =
  result = GetVal[string](t.ByteVector(off))

func VectorLen*(t: Vtable, off: uoffset): int =
  var newoff: uoffset = off + t.Pos
  newoff += t.Get(off, uoffset)
  return t.Get(newoff, uoffset).int

func Vector*(t: Vtable, off: uoffset): uoffset =
  let newoff: uoffset = off + t.Get(off, uoffset)
  var x = newoff + t.Get(off, uoffset)
  x += (uoffset.sizeof).uoffset
  return x

func Union*(t: Vtable, t2: var Vtable, off: uoffset) =
  let newoff: uoffset = off + t.Get(off, uoffset)
  t2.Pos = newoff + t.Get(off, uoffset)
  t2.Bytes = t.Bytes

func GetSlot*[T](t: Vtable, slot: voffset, d: T): T =
  let off = t.Offset(slot)
  if off == 0:
    return d
  return t.Get(t.Pos + off, T)

func GetOffsetSlot*[T: Offsets](t: Vtable, slot: voffset, d: T): T =
  let off = t.Offset(slot)
  if off == 0:
    return d
  return off
