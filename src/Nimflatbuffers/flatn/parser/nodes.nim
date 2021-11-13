import std/tables
from std/strutils import parseInt

import ../lexer/token
import ../lexer/tokenKind


const
   # For checking
   BasicTypes* = ["bool", "byte", "ubyte", "short", "ushort", "int", "uint", "float", "long", "ulong", "double",
                 "int8", "uint8", "int16", "uint16", "int32", "uint32", "int64", "uint64", "float32", "float64",
                 "string"]

   # For comparing
   BasicNimTypes* = ["bool",
                     "byte",
                     "byte",
                     "int8",
                     "uint8",
                     "int16",
                     "uint16",
                     "int32",
                     "uint32",
                     "int64",
                     "uint64",
                     "float32",
                     "float32",
                     "float64",
                     "float",
                     "string"]

   # For "converting"
   NimTypes* = {"bool": "bool",
               "byte": "int8",
               "ubyte": "byte",
               "short": "int16",
               "ushort": "uint16",
               "int": "int32",
               "uint": "uint32",
               "float": "float32",
               "long": "int32",
               "ulong": "uint32",
               "double": "float",
               "int8": "int8",
               "uint8": "int8",
               "int16": "int16",
               "uint16": "uint16",
               "int32": "int32",
               "uint32": "uint32",
               "int64": "int64",
               "uint64": "uint64",
               "float32": "float32",
               "float64": "float64",
               "string": "string"
               }.toTable

   NimSizes* = {"bool": 1,
                "byte": 1,
                "int8": 1,
                "uint8": 1,
                "int16": 2,
                "uint16": 2,
                "int32": 4,
                "uint32": 4,
                "int64": 8,
                "uint64": 8,
                "float32": 4,
                "float64": 8,
                "float": 8,
                "string": 4,
                "uoffset": 4
                } .toTable


type Node* = object
   lexeme*: string
   case kind*: TokenKind
      of tkNamespace:
         discard
      of tkEnum:
         enumType*: string
      of tkStruct:
         alignment*: int
         structSize*: int
      of tkTable:
         elements*: int16
      of tkUnion:
         discard
      of nkOpenArray:
         inlineSize*: int
         fieldSize*: int
      else:
         discard
   size*: int
   children*: seq[Node]

proc echoNode(node: Node, tab: string = ""): string =
   result.add $node.kind
   if len($node.lexeme) > 0:
      result.add " \"" & $node.lexeme & "\"\n"
   else:
      result.add "\n"
   if node.size != 0:
      result.add tab & "size: " & $node.size
      result.add "\n"
   if node.children.len != 0:
      for child in node.children:
         result.add tab & "   "
         result.add echoNode(child, tab & "   ")
   else:
      result.add("no children\n")

proc echoNodes*(nodes: seq[Node]): string =
   for node in nodes:
      result.add echoNode(node)


proc toNode*(this: Token): Node {.inline.} =
   Node(kind: this.kind, lexeme: this.lexeme)

proc isNamespace(this: Node) =
   doAssert this.kind == tkNamespace
   if this.children.len == 2:
      doAssert this.children[0].kind == tkIdentifier
      doAssert this.children[1].kind == tkSemiColon
   elif this.children.len == 4:
      doAssert this.children[0].kind == tkIdentifier
      doAssert this.children[1].kind == tkDot
      doAssert this.children[2].kind == tkIdentifier
      doAssert this.children[3].kind == tkSemiColon

proc addNamespace*(this: var seq[Node], x: Node) =
   x.isNamespace()
   if x.children.len == 2:
      this.add Node(
         kind: x.kind,
         lexeme: x.children[0].lexeme
      )
   elif x.children.len == 4:
      this.add Node(
         kind: x.kind,
         lexeme: x.children[0].lexeme & "." & x.children[2].lexeme
      )

proc parseEnum(this: var Node) =
   doAssert this.kind == tkEnum
   doAssert this.children[0].kind == tkIdentifier
   doAssert this.children[1].kind == tkColon
   doAssert this.children[2].kind == tkIdentifier
   doAssert this.children[2].lexeme in BasicTypes
   this.children[2].lexeme = NimTypes[this.children[2].lexeme]
   doAssert this.children[3].kind == tkLeftBrace
   doAssert this.children[^1].kind == tkRightBrace

   this.enumType = this.children[2].lexeme

   var
      Size: int = NimSizes[this.children[2].lexeme]
      childrenArr: seq[Node]
   childrenArr.add(
      Node(
         kind: tkColon,
         children: @[
            this.children[0],
            this.children[2]
            ]
      )
   )
   var
      braceChildren: seq[Node]
      defaultVal: int = 0

   for i in 2..<this.children.len:
      if this.children[i].kind in [tkNumber, tkComma]:
         continue
      elif this.children[i].kind == tkIdentifier:
         if this.children[i + 1].kind in [tkComma, tkRightBrace]:
            braceChildren.add(
               Node(
                  kind: tkEquals,
                  lexeme: "=",
                  children: @[
                     this.children[i],
                     Node(
                        kind: tkNumber,
                        size: Size,
                        lexeme: $defaultVal
                     )
                  ]
               )
            )
            inc defaultVal
         elif this.children[i + 1].kind == tkEquals:
            braceChildren.add(
               Node(
                  kind: tkEquals,
                  lexeme: "=",
                  children: @[
                     this.children[i],
                     Node(
                        kind: tkNumber,
                        lexeme: this.children[i + 2].lexeme
                     )
                  ]
               )
            )
            defaultVal = parseInt(this.children[i + 2].lexeme)
            inc defaultVal
#[      elif this.children[i].kind == tkEquals:
         braceChildren.add(
            Node(
               kind: tkEquals,
               lexeme: "=",
               children: @[
                  this.children[i - 1],
                  this.children[i + 1]
               ]
            )
         )
]#
   childrenArr.add(
      Node(
         kind: nkBraceExpr,
         children: braceChildren
      )
   )
   this.children = childrenArr

proc addEnum*(this: var seq[Node], x: Node) =
   var node = x
   node.parseEnum()
   this.add node

proc parseTable(this: var Node) =
   doAssert this.kind == tkTable
   doAssert this.children[0].kind == tkIdentifier
   doAssert this.children[1].kind == tkLeftBrace
   doAssert this.children[^1].kind == tkRightBrace

   var VectorAlignment: int
   var VectorInlineSize: int
   var childrenArr: seq[Node]
   childrenArr.add(this.children[0])

   var braceChildren: seq[Node]

   for i in 3..<this.children.len:
      if this.children[i].lexeme in BasicTypes or
         this.children[i].kind in [tkIdentifier, tkSemiColon, tkLeftSQBra, tkRightSQBra]:
         continue
      elif this.children[i].kind == tkColon:
         if this.children[i + 1].kind == tkLeftSQBra:
            if this.children[i + 2].lexeme in BasicTypes:
               this.children[i + 2].lexeme = NimTypes[this.children[i + 2].lexeme]
               this.children[i + 2].size = NimSizes[this.children[i + 2].lexeme]
               VectorAlignment = this.children[i + 2].size
               VectorInlineSize = VectorAlignment
            else:
               this.children[i + 2].size = 4
               VectorAlignment = this.children[i + 2].size
               VectorInlineSize = VectorAlignment
            braceChildren.add(
               Node(
                  kind: tkColon,
                  children: @[
                     this.children[i - 1],
                     Node(
                        kind: nkOpenArray, # vector
                        lexeme: "uoffset",
                        inlineSize: VectorInlineSize,
                        fieldSize: VectorAlignment,
                        children: @[
                           this.children[i + 2],
                        ]
                     )
                  ]
               )
            )
         elif this.children[i + 1].lexeme in BasicTypes:
            if this.children[i + 2].kind == tkEquals:
               echo "WARNING: defualt value not handled yet"
               this.children[i + 1].lexeme = NimTypes[this.children[i + 1].lexeme]
               this.children[i + 1].size = NimSizes[this.children[i + 1].lexeme]
               braceChildren.add(
                  Node(
                     kind: tkColon,
                     children: @[
                        this.children[i - 1],
                        Node(
                           kind: tkEquals,
                           children: @[
                              this.children[i + 1],
                              this.children[i + 3]
                           ]
                        )
                     ]
                  )
               )
            else:
               this.children[i + 1].lexeme = NimTypes[this.children[i + 1].lexeme]
               this.children[i + 1].size = NimSizes[this.children[i + 1].lexeme]
               braceChildren.add(
                  Node(
                     kind: tkColon,
                     children: @[
                        this.children[i - 1],
                        this.children[i + 1]
                     ]
                  )
               )
         else:
            braceChildren.add(
               Node(
                  kind: tkColon,
                  children: @[
                     this.children[i - 1],
                     this.children[i + 1]
                  ]
               )
            )
   childrenArr.add(
      Node(
         kind: nkBraceExpr,
         children: braceChildren
      )
   )

   this.children = childrenArr

proc addTable*(this: var seq[Node], x: Node) =
   var node = x
   node.parseTable()
   this.add node

proc parseStruct(this: var Node) =
   doAssert this.kind == tkStruct
   doAssert this.children[0].kind == tkIdentifier
   doAssert this.children[1].kind == tkLeftBrace
   doAssert this.children[^1].kind == tkRightBrace

   var StructSize: int
   var StructAlignment: int
   var childrenArr: seq[Node]
   childrenArr.add(this.children[0])

   var braceChildren: seq[Node]
   for i in 3..<this.children.len:
      if this.children[i].lexeme in BasicTypes or this.children[i].kind in [tkIdentifier, tkSemiColon]:
         continue
      elif this.children[i].kind == tkColon:
         if this.children[i + 1].lexeme in BasicTypes:
            this.children[i + 1].lexeme = NimTypes[this.children[i + 1].lexeme]
            this.children[i + 1].size = NimSizes[this.children[i + 1].lexeme]
            if StructAlignment <= this.children[i + 1].size:
               StructAlignment = this.children[i + 1].size
            inc StructSize, this.children[i + 1].size
         else:
            echo "WARNING SIZE IS NOT CORRECT"
         braceChildren.add(
            Node(
               kind: tkColon,
               children: @[
                  this.children[i - 1],
                  this.children[i + 1]
               ]
            )
         )
   childrenArr.add(
      Node(
         kind: nkBraceExpr,
         children: braceChildren,
      )
   )

   this.alignment = StructAlignment
   this.structSize = StructSize
   this.children = childrenArr

proc addStruct*(this: var seq[Node], x: Node) =
   var node = x
   node.parseStruct()
   this.add node


proc parseUnion(this: var Node) =
   doAssert this.kind == tkUnion
   doAssert this.children[0].kind == tkIdentifier
   doAssert this.children[1].kind == tkLeftBrace
   for i in this.children[2..^2]:
      doAssert i.kind == tkIdentifier or i.kind == tkComma
   doAssert this.children[^1].kind == tkRightBrace

   var childrenArr: seq[Node]
   childrenArr.add(this.children[0])

   var braceChildren: seq[Node]

   for i in 2..<this.children.len:
      if this.children[i].lexeme in BasicTypes or
         this.children[i].kind in [tkComma, tkSemiColon]:
         continue
      elif this.children[i].kind == tkIdentifier:
            braceChildren.add(
               Node(
                  kind: tkIdentifier,
                  lexeme: this.children[i].lexeme
               )
            )


   childrenArr.add(
      Node(
         kind: nkBraceExpr,
         children: braceChildren
      )
   )
   this.children = childrenArr

proc addUnion*(this: var seq[Node], x: Node) =
   var node = x
   node.parseUnion()
   this.add node
