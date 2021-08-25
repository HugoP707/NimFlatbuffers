import std/os


when isMainModule:
   doAssert paramCount() == 2
   copyDir(paramStr(1), paramStr(2))
