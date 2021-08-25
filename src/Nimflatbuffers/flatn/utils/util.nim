proc `*`*(a: string, b: int): string =
   for i in 0..b:
      result.add a

proc isAlpha*(c: char): bool =
   return (c >= 'a' and c <= 'z') or
          (c >= 'A' and c <= 'Z') or
          c == '_'

proc FirstLetterCap*(s: string): string =
   if s[0] in {'a'..'z'}:
      result = $(chr(ord(s[0]) - (ord('a') - ord('A')))) & s[1..^1]
   else:
      result = s
