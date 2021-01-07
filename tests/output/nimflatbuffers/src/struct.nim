import table


type FlatObj* {.inheritable.} = object
  tab*: Vtable

func Table*(this: var FlatObj): Vtable = this.tab

func Init*(this: var FlatObj, buf: seq[byte], i: uoffset) =
  this.tab.Bytes = buf
  this.tab.Pos = i

func GetRootAs*[T](buf: seq[byte], offset: uoffset): var T =
  var n = Get[uoffset](buf[offset..^1])
  result.Init(buf, n+offset)
