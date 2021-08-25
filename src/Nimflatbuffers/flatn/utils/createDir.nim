import std/os


when isMainModule:
   doAssert paramCount() == 1
   createDir(paramStr(1))
