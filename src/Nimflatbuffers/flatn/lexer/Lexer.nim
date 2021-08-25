import tables
import strutils
import ../utils/util
import token, tokenKind


const
   keywords = {
      "namespace": tkNamespace,
      "struct": tkStruct,
      "table": tkTable,
      "union": tkUnion,
      "enum": tkEnum,
   }.toTable

   NonSupportedKeywords = {
      "attribute": tkNone
   }.toTable

   NimKeywords = [
   "addr", "and", "as", "asm",
   "bind", "block", "break",
   "case", "cast", "concept", "const", "continue", "converter",
   "defer", "discard", "distinct", "div", "do",
   "elif", "else", "end", "enum", "except", "export",
   "finally", "for", "from", "func",
   "if", "import", "in", "include", "interface", "is", "isnot", "iterator",
   "let",
   "macro", "method", "mixin", "mod",
   "nil", "not", "notin",
   "object", "of", "or", "out",
   "proc", "ptr",
   "raise", "ref", "return",
   "shl", "shr", "static",
   "template", "try", "tuple", "type",
   "using",
   "var",
   "when", "while",
   "xor",
   "yield"
   ]

type Lexer* = object
   source*: string
   tokens*: seq[Token]
   start*, current*, line*: int

proc initLexer*(this: var Lexer, file: string) =
   this.source = file
   this.start = 0
   this.current = 0
   this.line = 1

proc isAtEnd*(this: Lexer): bool =
   result = this.current >= this.source.len

proc advance*(this: var Lexer): char {.discardable.} =
   result = this.source[this.current]
   inc this.current

proc skipLine*(this: var Lexer) =
   while this.advance() != '\L': discard
   this.line += 1

proc peek*(this: var Lexer): char =
   if this.isAtEnd():
      result = '\0'
   else:
      result = this.source[this.current]

proc peekNext(lex: var Lexer): char =
   # Returns the current + 1 char without moving to the next one
   if lex.current + 1 >= lex.source.len:
      result = '\0'
   else:
      result = lex.source[lex.current+1]

proc makeNim(str: string): string =
   if str in NimKeywords:
      result = "" & str & "N"
   else:
      result = "" & str & ""


template addToken*(this: var Lexer, kin: TokenKind) =
   this.tokens.add(
      Token(
         line: this.line,
         kind: kin,
         lexeme: this.source[this.start..<this.current].makeNim()
      )
   )

template addFloatToken(this: var Lexer, literal: float) =
   # Add float token along with metadata
   this.tokens.add(
      Token(
         line: this.line,
         kind: tkNumber,
         lexeme: this.source[this.start..<this.current],
         floatVal: literal
      )
   )

proc identifier*(this: var Lexer) =
   while isAlphaNumeric(this.peek()) or isAlpha(this.peek()): this.advance()
   let
      text = this.source[this.start..<this.current]

   if keywords.contains(text):
      let kind = keywords[text]
      this.addToken(kind)
   elif NonSupportedKeywords.contains(text):
      quit(text & "s are not supported")
   else:
      let kind = tkIdentifier
      this.addToken(kind)

proc scanNumber(this: var Lexer) =
   while isDigit(this.peek()): this.advance()
   if this.peek() == '.' and isDigit(this.peekNext()):
      this.advance()
      while isDigit(this.peek()): this.advance()
   let value = this.source[this.start..this.current-1]
   this.addFloatToken(parseFloat(value))

proc scanToken(this: var Lexer) =
   # Infers the type of lexical token from its string representation
   let c: char = this.advance()
   case c:
      of '(':
         this.addToken(tkLeftParen)
      of ')':
         this.addToken(tkRightParen)
      of '{':
         this.addToken(tkLeftBrace)
      of '}':
         this.addToken(tkRightBrace)
      of '[':
         this.addToken(tkLeftSQBra)
      of ']':
         this.addToken(tkRightSQBra)
      of ',':
         this.addToken(tkComma)
      of ':':
         this.addToken(tkColon)
      of ';':
         this.addToken(tkSemicolon)
      of '.':
         this.addToken(tkDot)
      of '=':
         this.addToken(tkEquals)
      of '\r', '\t', ' ': # Ignore whitespace
         discard
      of '/':
         this.skipLine()
      of '\L': # New line char '\n'
         this.line += 1
      else:
         if isDigit(c):
            this.scanNumber()
         elif isAlpha(c):
            this.identifier()
         else:
            quit($this.line & ": " & this.source[this.start..this.current] & " Unrecognized letter " & $c)

proc generate_tokens*(this: var Lexer) =
   while not(this.current >= this.source.len):
      this.start = this.current
      this.scanToken()

   this.tokens.add Token(line: this.line, kind: tkEof, lexeme: "")



