import ../lexer/token
import ../lexer/tokenKind
import nodes


type Parser* = object
  current*: int
  tokens*: seq[Token]
  nodes*: seq[Node]

  symbols*: seq[string]
  badSymbols*: seq[string]

  case kind*: Tokenkind
    of tkNumber:
      floatVal*: float
    of tkNamespace..tkEnum:
      discard
    else:
      strVal*: string

proc initParser*(this: var Parser, file: seq[Token]) =
  this.tokens = file
  this.current = 0

proc advance*(this: var Parser): Token {.discardable.} =
  result = this.tokens[this.current]
  inc this.current

proc goBack*(this: var Parser) =
  dec this.current

template peek*(this: Parser): Token = this.tokens[this.current]

proc parse*(this: var Parser) =
  while not(this.current >= this.tokens.len - 1):
    if this.peek().kind == tkNamespace:
      var childrenArr: seq[Node]
      while this.advance().kind != tkSemiColon:
        childrenArr.add toNode(this.peek())

      this.nodes.addNamespace(
        Node(
          kind: tkNamespace,
          children: childrenArr
        )
      )
    elif this.peek().kind == tkEnum:
      var childrenArr: seq[Node]
      while this.advance().kind != tkRightBrace:
        childrenArr.add toNode(this.peek())

      this.nodes.addEnum(
        Node(
          kind: tkEnum,
          children: childrenArr
        )
      )
    elif this.peek().kind == tkTable:
      var childrenArr: seq[Node]
      while this.advance().kind != tkRightBrace:
        childrenArr.add toNode(this.peek())

      this.nodes.addTable(
        Node(
          kind: tkTable,
          children: childrenArr
        )
      )
    elif this.peek().kind == tkStruct:
      var childrenArr: seq[Node]
      while this.advance().kind != tkRightBrace:
        childrenArr.add toNode(this.peek())
      #this.goBack()

      this.nodes.addStruct(
        Node(
          kind: tkStruct,
          children: childrenArr
        )
      )
    elif this.peek().kind == tkUnion:
      var
        childrenArr: seq[Node]
      while this.advance().kind != tkRightBrace:
        childrenArr.add toNode(this.peek())

      this.nodes.addUnion(
        Node(
          kind: tkUnion,
          children: childrenArr
        )
      )
    elif this.peek().lexeme == "root_type":
      this.advance()
      this.advance()
      this.advance()
    else:
      echo("ERROR IN TOKEN: ", this.peek().kind, " ", this.peek().lexeme)
      this.advance()