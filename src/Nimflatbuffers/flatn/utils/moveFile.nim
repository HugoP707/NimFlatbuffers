import std/os


when isMainModule:
  doAssert paramCount() == 2
  moveFile(paramStr(1), paramStr(2))
