import std/macros
import std/os

from std/strutils import replace, contains, parseInt, join
from std/sequtils import toSeq

import ../util
import ../lexer/token
import ../lexer/tokenKind
import ../lexer/Lexer
import ../parser/nodes
import ../parser/Parser


var
  structs: seq[string]
  tables: seq[string]

iterator toEnumFields(node: Node): NimNode =
  for child in node.children[1].children:
    yield newNimNode(nnkEnumFieldDef).add(
      ident child.children[0].lexeme,
      newNimNode(nnkDotExpr).add(
        newIntLitNode parseInt(child.children[1].lexeme),
        ident node.children[0].children[1].lexeme
      )
    )

iterator fieldTypeSlots(node: Node): (string, string, int, int, Node) =
  var maxSize: int = 0
  var size: int = 0
  for child in node.children[1].children:
    if child.children[1].kind == nkOpenArray:
      if child.children[1].children[0].lexeme in ["bool", "byte"]:
        if maxSize < 1:
          maxSize = 1
      elif child.children[1].children[0].lexeme.contains("8"):
        if maxSize < 1:
          maxSize = 1
      elif child.children[1].children[0].lexeme.contains("16"):
        if maxSize < 2:
          maxSize = 2
      elif child.children[1].children[0].lexeme.contains("32"):
        if maxSize < 4:
          maxSize = 4
      elif child.children[1].children[0].lexeme.contains("64"):
        if maxSize < 8:
          maxSize = 8
      elif child.children[1].children[0].lexeme == "string":
        if maxSize < 4:
          maxSize = 4
      else:
        if maxSize < 4:
          maxSize = 4
    elif child.children[1].lexeme in ["bool", "byte"]:
      if maxSize < 1:
        maxSize = 1
    elif child.children[1].lexeme.contains("8"):
      if maxSize < 1:
        maxSize = 1
    elif child.children[1].lexeme.contains("16"):
      if maxSize < 2:
        maxSize = 2
    elif child.children[1].lexeme.contains("32"):
      if maxSize < 4:
        maxSize = 4
    elif child.children[1].lexeme.contains("64"):
      if maxSize < 8:
        maxSize = 8
    elif child.children[1].lexeme == "string":
      if maxSize < 4:
        maxSize = 4
    else:
      if maxSize < 4:
        maxSize = 4

  var i: int = 1
  for child in node.children[1].children:
    if child.children[1].children.len == 1:
      yield (child.children[0].lexeme, child.children[1].children[0].lexeme, (i + 1) * 2, maxSize, child)
    else:
      yield (child.children[0].lexeme, child.children[1].lexeme, (i + 1) * 2, maxSize, child)
    inc i

iterator fieldTypeSlotsT(node: Node): (string, string, int) =
  var maxSize: int = 0
  for child in node.children[1].children:
    if child.children[1].lexeme in ["bool", "byte"]:
      if maxSize < 1:
        maxSize = 1
    elif child.children[1].lexeme.contains("8"):
      if maxSize < 1:
        maxSize = 1
    elif child.children[1].lexeme.contains("16"):
      if maxSize < 2:
        maxSize = 2
    elif child.children[1].lexeme.contains("32"):
      if maxSize < 4:
        maxSize = 4
    elif child.children[1].lexeme.contains("64"):
      if maxSize < 8:
        maxSize = 8
    elif child.children[1].lexeme == "string":
      quit("dont know wtf to do with strings")
    else:
      maxSize = 4

  var i: int = 0
  for child in node.children[1].children:
    yield (child.children[0].lexeme, child.children[1].lexeme, i)
    inc i, maxSize

proc stringify(n: NimNode): string =
  n.repr.replace("type\n  ", "type ").replace(";\n", "; ").replace("; )", ")")

proc newStructGetter(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field
    ),
    [
      ident typ,
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      )
    ],
    parseStmt(
      "result = this.tab.Get[:" & typ & "](this.tab.Pos + " & $slo & ")\n"
    )
  )

proc newStructGetterT(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field
    ),
    [
      ident typ,
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      )
    ],
    parseStmt(
      "result = this.tab.Get[:" & typ & "](this.tab.Pos + " & $slo & ")\n"
    )
  )

proc newStructSetter(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "mutate" & FirstLetterCap(field)
    ),
    [
      ident "bool",
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident "n",
        ident typ,
        newEmptyNode()
      ),
      newEmptyNode()
    ],
    parseStmt(
      "result = this.tab.Mutate(this.tab.Pos + " & $slo & ", n)"
    )
  )
  echo(result.repr)

proc newStructCreator(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "mutate" & FirstLetterCap(field)
    ),
    [
      ident "bool",
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident "n",
        ident typ,
        newEmptyNode()
      ),
      newEmptyNode()
    ],
    parseStmt(
      "result = this.tab.Mutate(this.tab.Pos + " & $slo & ", n)"
    )
  )
  echo(result.repra)

proc newStruct(node: Node): seq[string] =
  var
    objName = nnkPostfix.newTree(ident"*", ident(node.children[0].lexeme))
    mutatorProcs: seq[string]

  var
    objType = nnkObjectTy.newTree(
      newEmptyNode(),
      nnkOfInherit.newTree(
        ident"FlatObj"
      ),
      newEmptyNode() # objFields
    )

  for field, typ, slo in node.fieldTypeSlotsT:
    mutatorProcs.add ("\n")
    if typ notin BasicNimTypes:
      mutatorProcs.add newStructGetter(objName[1].strVal, field, typ, slo).stringify
      mutatorProcs.add ("\n")
      mutatorProcs.add newStructSetter(objName[1].strVal, field, typ, slo).stringify
    else:
      mutatorProcs.add newStructGetterT(objName[1].strVal, field, typ, slo).stringify
      mutatorProcs.add ("\n")
  result.add nnkTypeSection.newTree(nnkTypeDef.newTree(objName, newEmptyNode(), objType)).stringify
  result.add ("\n")
  result.add mutatorProcs
  result.add ("\n\n")
  #result.add newStructCreator(node).repr
  #result.add newTableEnder(node).repr

proc newTableGetter(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field
    ),
    [
      nnkVarTy.newTree(
        ident typ
      ),
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      )
    ],
    parseStmt(
      "var o = this.tab.Offset(" & $slo & ").uoffset\n" &
      "if o != 0:\n" &
      "  " & "  result = this.tab.Get[:" & typ & "](o + this.tab.Pos)\n" &
      "else:\n" &
      "  " & "  result = default(type(result))\n"
    )
  )

proc newTableSetter(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "mutate" & FirstLetterCap(field)
    ),
    [
      ident "bool",
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident "n",
        ident typ,
        newEmptyNode()
      )
    ],
    parseStmt(
      "result = this.tab.MutateSlot(" & $slo & ", n)\n"
    )
  )

proc newTableArrayGetter(obj, field, typ: string, slo: int, size: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field
    ),
    [
      ident typ,
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident "j",
        ident "int",
        newEmptyNode()
      )
    ],
    parseStmt(
      "var o = this.tab.Offset(" & $slo & ").uoffset\n" &
      "if o != 0:\n" &
      "  var x = this.tab.Vector(o)\n" &
      "  x += j * maxSize\n" &
      "  result = this.tab.Get[:" & typ & "](o + this.tab.Pos)\n" &
      "else:\n" &
      "  result = false\n"
    )
  )
#[
		x := rcv._tab.Vector(o)
		x += flatbuffers.UOffsetT(j) * 4
		x = rcv._tab.Indirect(x)
		obj.Init(rcv._tab.Bytes, x)
		return true
	}
	return false
]#
proc newTableArrayLength(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "mutate" & FirstLetterCap(field)
    ),
    [
      ident "bool",
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident "n",
        ident typ,
        newEmptyNode()
      )
    ],
    parseStmt(
      "result = this.tab.MutateSlot(" & $slo & ", n)\n"
    )
  )

proc newTableAdder(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident obj & "Add" & FirstLetterCap(field)
    ),
    [
      newEmptyNode(),
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident "Builder"
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident field,
        ident typ,
        newEmptyNode()
      )
    ],
    parseStmt(
      "this.PrependSlot(" & $(slo div 2 - 2) & ", " & field & ", default(" & typ & "))\n"
    )
  )

proc newTableArrayAdder(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident obj & "Add" & FirstLetterCap(field)
    ),
    [
      newEmptyNode(),
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident "Builder"
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident field,
        ident typ,
        newEmptyNode()
      )
    ],
    parseStmt(
      "this.PrependSlot(" & $(slo div 2 - 2) & ", " & field & ", default(" & typ & "))\n"
    )
  )

proc newTableStarter(node: Node): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident FirstLetterCap(node.children[0].lexeme) & "Start"
    ),
    [
      newEmptyNode(),
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident "Builder"
        ),
        newEmptyNode()
      ),
    ],
    parseStmt(
      "this.StartObject(" & $node.children[1].children.len & ")\n"
    )
  )
proc newTableEnder(node: Node): NimNode =
  result = parseStmt("proc End*(this: var Builder): uoffset =\n" &
  "  result = this.EndObject()\n")

proc newTable(node: Node): seq[string] =
  var
    objName = nnkPostfix.newTree(ident"*", ident(node.children[0].lexeme))
    mutatorProcs: seq[string]

  var
    objType = nnkObjectTy.newTree(
      newEmptyNode(),
      nnkOfInherit.newTree(
        ident"FlatObj"
      ),
      newEmptyNode() # objFields
    )

  for field, typ, slo, size, child in node.fieldTypeSlots:
    if child.kind == nkOpenArray:
      mutatorProcs.add ("\n")
      mutatorProcs.add newTableArrayGetter(objName[1].strVal, field, typ, slo, size).stringify
      mutatorProcs.add ("\n")
      mutatorProcs.add newTableArrayLength(objName[1].strVal, field, typ, slo).stringify
    else:
      mutatorProcs.add ("\n")
      mutatorProcs.add newTableGetter(objName[1].strVal, field, typ, slo).stringify
      mutatorProcs.add ("\n")
      mutatorProcs.add newTableSetter(objName[1].strVal, field, typ, slo).stringify

  result.add nnkTypeSection.newTree(nnkTypeDef.newTree(objName, newEmptyNode(), objType)).stringify
  result.add ("\n")
  result.add mutatorProcs
  result.add ("\n")
  result.add newTableStarter(node).stringify
  for field, typ, slo, size, child in node.fieldTypeSlots:
    result.add ("\n")
    if child.kind == nkOpenArray:
      result.add newTableArrayAdder(objName[1].strVal, field, typ, slo).stringify
    else:
      result.add newTableAdder(objName[1].strVal, field, typ, slo).stringify
  #result.add newTableEnder(node).stringify
  result.add ("\n\n")

proc newEnum(node: Node): seq[string] =
  var
    objName = ident(node.children[0].children[0].lexeme)

  result.add newEnum(
    name = objName,
    fields = toSeq(node.toEnumFields),
    public = true, pure = false
  ).stringify & "\n\n\n"

proc newNodeFromFlat(node: Node): (seq[string], string) =
  if node.kind == tkTable:
    result = (newTable(node), node.children[0].lexeme)
  elif node.kind == tkStruct:
    result = (newStruct(node), node.children[0].lexeme)
  elif node.kind == tkEnum:
    result = (newEnum(node), node.children[0].children[0].lexeme)
  else:
    quit("ERROR, not supported node type: " & $node.kind & "\n\n" & echoNodes(@[node]))

macro generateCodeImpl*(path, filename: static[string]): untyped =
  let
    path = splitFile(path).dir
    resourcepath = path / filename
  echo("RESOURCE PATH: ", resourcepath)

  var
    file = staticRead(resourcepath)
    lexer: Lexer
    parser: Parser
    outputFiles: seq[(string, string)]

  lexer.initLexer(file)
  lexer.generate_tokens()

  parser.initParser(lexer.tokens)
  parser.parse()
  echo(echoNodes(parser.nodes))

  var header =
    "import ../nimflatbuffers\n\n\n"

  var
    currentFile: string = "output"
    fileContents: string = header
    currentNode: seq[string]
    currentName: string

  for node in parser.nodes:
    if node.kind == tkNamespace:
      currentFile = node.lexeme.replace(".", "_") & ".nim"
      echo(echoNodes(@[node]))
    else:
      (currentNode, currentName) = newNodeFromFlat(node)
      for str in currentNode:
        fileContents.add(str)

  echo(currentFile)
  echo(path)
  writeFile(path & "/" & currentFile, fileContents[0..^3])

template generateCode*(file: static[string]) =
  generateCodeImpl(instantiationInfo(-1, fullPaths = true).filename, file)
