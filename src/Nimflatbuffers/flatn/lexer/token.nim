import tokenKind
import strformat


type Token* = object
   line*: int
   lexeme*: string
   case kind*: Tokenkind
      of tkNumber:
         floatVal*: float
      of tkNamespace..tkEnum:
         discard
      else:
         strVal*: string

# Stringify token
proc `$`*(token: Token): string =
   return fmt"{$token.kind}, {$token.lexeme}, {$token.line}"