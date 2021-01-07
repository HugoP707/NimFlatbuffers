import std/[os, macros]

from std/sequtils import toSeq
from std/strutils import replace, contains, parseInt, join

import ../utils/util
import ../parser/[nodes, Parser]
import ../lexer/[Lexer, tokenKind]


var
  structs {.compileTime.} : seq[Node]
  tabls {.compileTime.} : seq[Node]
  enums {.compileTime.} : seq[Node]
  unions {.compileTime.} : seq[Node]


iterator names(nodes: var seq[Node]): string =
  for node in nodes:
    yield node.children[0].children[0].lexeme

iterator namesU(nodes: var seq[Node]): string =
  for node in nodes:
    yield node.children[0].lexeme

proc getName(nodes: var seq[Node], name: string): Node =
  for node in nodes:
    if node.children[0].children[0].lexeme == name:
      return node

proc findStruct(ident: string): Node {.used.} =
  for node in structs:
    if node.lexeme == ident:
      return node

proc findTable(ident: string): Node {.used.} =
  for node in tabls:
    if node.lexeme == ident:
      return node

proc findEnum(ident: string): Node {.used.} =
  for node in enums:
    if node.lexeme == ident:
      return node

iterator toEnumFields(node: Node): NimNode =
  for child in node.children[1].children:
    yield newNimNode(nnkEnumFieldDef).add(
      ident child.children[0].lexeme,
      newNimNode(nnkDotExpr).add(
        newIntLitNode parseInt(child.children[1].lexeme),
        ident node.children[0].children[1].lexeme
      )
    )

iterator toUnionFields(node: Node): NimNode =
  var idx: uint8 = 0
  for child in node.children[1].children:
    yield newNimNode(nnkEnumFieldDef).add(
      ident child.lexeme,
      newLit idx
    )
    inc idx

iterator fieldTypeSlots(node: Node): (string, string, int, int, int, Node) =
  var maxSize: int = 0
  #var size: int = 0
  for child in node.children[1].children:
    if child.children[1].kind == nkOpenArray:
      if maxSize < 4:
        maxSize = 4

    elif child.children[1].kind == tkStruct:
      if maxSize < child.children[1].structSize:
        maxSize = child.children[1].structSize
      #[
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
      elif child.children[1].children[0].lexeme == "uoffset":
        if maxSize < 4:
          maxSize = 4
      else:
        if maxSize < 4:
          maxSize = 4
          ]#
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
    elif child.children[1].lexeme == "uoffset":
      if maxSize < 4:
        maxSize = 4
    else:
      if maxSize < 4:
        maxSize = 4

  var
    i: int = 1
    x: int = 0
  for child in node.children[1].children:
    if child.children[1].children.len == 1:
      if child.kind == tkUnion:
        yield (child.children[0].lexeme, child.children[1].children[0].lexeme, (i + 1) * 2, x, maxSize, child)
        inc x
      else:
        yield (child.children[0].lexeme, child.children[1].children[0].lexeme, (i + 1) * 2, x, maxSize, child)
    else:
      yield (child.children[0].lexeme, child.children[1].lexeme, (i + 1) * 2, x, maxSize, child)
    inc i
    inc x

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
    elif child.children[1].lexeme == "uoffset":
      if maxSize < 4:
        maxSize = 4
      #quit("dont know wtf to do with strings")
    else:
      maxSize = 4

  var i: int = 0
  for child in node.children[1].children:
    yield (child.children[0].lexeme, child.children[1].lexeme, i)
    inc i, maxSize

proc stringify(n: NimNode): string =
  #n.repr.replace("type\n  ", "type ").replace("; )", ")")
  n.repr

proc newEnder(node: Node): NimNode {.used.} =
  result = parseStmt("proc " & node.children[0].lexeme & "End*(this: var Builder): uoffset =\n" &
  "  result = this.EndObject()\n")

proc newStructGetter(obj, field, typ: string, off: int): NimNode =
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
      "result = this.tab.Get[:" & typ & "](this.tab.Pos + " & $off & ")\n"
    )
  )

proc newStructGetterT(obj, field, typ: string, off: int): NimNode =
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
      "result = this.tab.Get[:" & typ & "](this.tab.Pos + " & $off & ")\n"
    )
  )

proc newStructSetter(obj, field, typ: string, off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "`" & field & "=`"
    ),
    [
      # TODO: dont return bool
      newEmptyNode(),
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
      "discard this.tab.Mutate(this.tab.Pos + " & $off & ", n)"
    )
  )

proc newStructCreator(node: Node): NimNode {.used.} =
  var
    args: seq[NimNode]
    toPrepend: string

  args = @[
    newEmptyNode(),
    nnkIdentDefs.newTree(
      ident "this",
      nnkVarTy.newTree(
        ident "Builder"
      ),
      newEmptyNode()
    )
  ]

  for child in node.children[1].children:
    toPrepend.add "this.Prepend(" & child.children[0].lexeme & ")"
    toPrepend.add "\n"
    args.add nnkIdentDefs.newTree(
      ident child.children[0].lexeme,
      ident child.children[1].lexeme,
      newEmptyNode()
    )

  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "Create" & node.children[0].lexeme
    ),
    args,
    parseStmt(
      "this.Prep(" & $node.alignment & ", " & $node.structSize & ")\n" &
      toPrepend

    )
  )

proc newStruct(node: Node): seq[string] =
  echo "newStrict"
  var
    objName = nnkPostfix.newTree(ident"*", ident(node.children[0].lexeme))
    #objSize = node.size
    mutatorProcs: seq[string]

  var
    objType = nnkObjectTy.newTree(
      newEmptyNode(),
      nnkOfInherit.newTree(
        ident"FlatObj"
      ),
      newEmptyNode() # objFields
    )

  for field, typ, off in node.fieldTypeSlotsT:
    mutatorProcs.add ("\n")
    if typ notin BasicNimTypes:
      if typ in toSeq(unions.namesU):
        echo("ERROR IN FIELD: [", field, "]")
        echo("INVALID TYPE: [", typ, "] SKIPPING...")
        mutatorProcs.add("# SKIPPED FIELD, " & field & " of type " & typ)
      else:
        # TODO: ~~Create acutal Getter and Setter for structs~~ confirm the getters and setters are correct
        mutatorProcs.add newStructGetterT(objName[1].strVal, field, typ, off).stringify
        mutatorProcs.add ("\n")
        mutatorProcs.add newStructSetter(objName[1].strVal, field, typ, off).stringify
    else:
      mutatorProcs.add newStructGetter(objName[1].strVal, field, typ, off).stringify
      # TODO: Create acutal Setter for structs
      mutatorProcs.add newStructSetter(objName[1].strVal, field, typ, off).stringify

  result.add nnkTypeSection.newTree(nnkTypeDef.newTree(objName, newEmptyNode(), objType)).stringify
  result.add ("\n")
  result.add mutatorProcs
  result.add ("\n")
  result.add newStructCreator(node).stringify
  result.add ("\n\n")

proc newTableGetter(obj, field, typ: string, off: int): NimNode =
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
      "var o = this.tab.Offset(" & $off & ").uoffset\n" &
      "if o != 0:\n" &
      "  " & "  result = this.tab.Get[:" & typ & "](o + this.tab.Pos)\n" &
      "else:\n" &
      "  " & "  result = default(type(result))\n"
    )
  )

proc newTableGetterT(obj, field, typ: string; off: int): NimNode =
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
    ],
    parseStmt(
      #"var obj: " & typ & "\n" &
      "var o = this.tab.Offset(" & $off & ").uoffset\n" &
      "if o != 0:\n" &
      "  " & "  var x = this.tab.Indirect(o + this.tab.Pos)\n" &
      "  " & "  result.Init(this.tab.Bytes, x)\n" &
      "else:\n" &
      "  " & "  result = default(type(result))\n"
    )
  )

proc newTableSetter(obj, field, typ: string, off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "`" & field & "=`"
    ),
    [
      newEmptyNode(),
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
      "discard this.tab.MutateSlot(" & $off & ", n)\n"
    )
  )

proc newTableArrayGetter(obj, field, typ: string; off, inlineSize, size: int): NimNode =
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
      "var o = this.tab.Offset(" & $off & ").uoffset\n" &
      "if o != 0:\n" &
      "  var x = this.tab.Vector(o)\n" &
      "  x += j.uoffset * " & $inlineSize & ".uoffset\n" &
      "  result = this.tab.Get[:" & typ & "](o + this.tab.Pos)\n" &
      "else:\n" &
      "  discard\n"
    )
  )

proc newTableArrayLength(obj, field, typ: string, off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field & "Size"
    ),
    [
      newEmptyNode(),
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
      "discard this.tab.MutateSlot(" & $off & ", n)\n"
    )
  )

proc newTableUnionTypeGetter(obj, field, typ: string, off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field & "Type"
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
      "var o = this.tab.Offset(" & $off & ").uoffset\n" &
      "if o != 0:\n" &
      "  result = this.tab.Get[:" & typ & "](o + this.tab.Pos)\n" &
      "else:\n" &
      "  result = default(type(result))\n"
    )
  )

proc newTableUnionTypeSetter(obj, field, typ: string, off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "`" & field & "Type=`"
    ),
    [
      newEmptyNode(),
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
      "discard this.tab.MutateSlot(" & $off & ", n)\n"
    )
  )

proc newTableUnionGetter(obj, field, typ: string; off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident field
    ),
    [
      ident "FlatObj",
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      #[nnkIdentDefs.newTree(
        ident "obj",
        nnkVarTy.newTree(
          ident "FlatObj"
        ),
        newEmptyNode()
      )]#
    ],
    parseStmt(
      #"var obj: " & typ & "\n" &
      "var o = this.tab.Offset(" & $off & ").uoffset\n" &
      "if o != 0:\n" &
      "  this.tab.Union(result.tab, o)\n" &
      #"  " & "  result = true\n" &
      "else:\n" &
      "  discard"
      #"  " & "  result = false\n"
    )
  )
# NO SETTERS IN THE API!!!
proc newTableUnionSetter(obj, field, typ: string; off: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident "`" & field & "=`"
    ),
    [
      newEmptyNode(),
      nnkIdentDefs.newTree(
        ident "this",
        nnkVarTy.newTree(
          ident obj
        ),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        ident "obj",
        nnkVarTy.newTree(
          ident "FlatObj"
        ),
        newEmptyNode()
      ),
    ],
    parseStmt(
      #"var obj: " & typ & "\n" &
      "var o = this.tab.Offset(" & $off & ").uoffset\n" &
      "if o != 0:\n" &
      "  this.tab.Union(obj.tab, o)\n" &
      #"  " & "  result = true\n" &
      "else:\n" &
      "  discard"
      #"  " & "  result = false\n"
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
      "this.PrependSlot(" & $slo & ", " & field & ", default(" & typ & "))\n"
    )
  )

proc newTableEnumAdder(obj, field, typ: string, slo: int): NimNode =
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
      "this.PrependSlot(" & $slo & ", " & field & ", default(" & typ & "))\n"
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
      "this.PrependSlot(" & $slo & ", " & field & ", default(" & typ & "))\n"
    )
  )

proc newTableUnionTypeAdder(obj, field, typ: string, slo: int): NimNode =
  result = newProc(
    nnkPostFix.newTree(
      ident "*",
      ident obj & "Add" & FirstLetterCap(field) & "Type"
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
      "this.PrependSlot(" & $slo & ", " & field & ", default(" & typ & "))\n"
    )
  )

proc newTableUnionAdder(obj, field, typ: string, slo: int): NimNode =
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
      "this.PrependSlot(" & $(slo + 1) & ", " & field & ", default(" & typ & "))\n"
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
      newEmptyNode()
    )

  for field, typ, off, slo, size, child in node.fieldTypeSlots:
    if child.children[1].kind == nkOpenArray:
      mutatorProcs.add ("\n")
      mutatorProcs.add newTableArrayGetter(objName[1].strVal, field, "uoffset", off, child.children[1].inlineSize, size).stringify
      mutatorProcs.add ("\n")
      mutatorProcs.add newTableArrayLength(objName[1].strVal, field, "uoffset", off).stringify
    else:
      if typ notin BasicNimTypes:
        if typ in toSeq(unions.namesU):
          mutatorProcs.add ("\n")
          mutatorProcs.add newTableUnionTypeGetter(objName[1].strVal, field, typ & "Type", off).stringify
          mutatorProcs.add ("\n")
          mutatorProcs.add newTableUnionTypeSetter(objName[1].strVal, field, typ & "Type", off).stringify
          mutatorProcs.add ("\n")
          mutatorProcs.add newTableUnionGetter(objName[1].strVal, field, "uoffset", off).stringify
          #mutatorProcs.add ("\n")
          #mutatorProcs.add newTableUnionSetter(objName[1].strVal, field, getName(enums, typ).enumType, slo).stringify
        elif typ in toSeq(enums.names):
          mutatorProcs.add ("\n")
          mutatorProcs.add newTableGetter(objName[1].strVal, field, getName(enums, typ).enumType, slo).stringify
          mutatorProcs.add ("\n")
          mutatorProcs.add newTableSetter(objName[1].strVal, field, getName(enums, typ).enumType, slo).stringify
        else:
          mutatorProcs.add ("\n")
          mutatorProcs.add newTableGetterT(objName[1].strVal, field, typ, off).stringify
          # TODO: make this only added when --gen-mutable is passed (and also allow for --gen-mutable to be passed :p )
          #mutatorProcs.add ("\n")
          #mutatorProcs.add newTableSetter(objName[1].strVal, field, typ, off).stringify
      else:
        mutatorProcs.add ("\n")
        mutatorProcs.add newTableGetter(objName[1].strVal, field, typ, off).stringify
        mutatorProcs.add ("\n")
        mutatorProcs.add newTableSetter(objName[1].strVal, field, typ, off).stringify

  result.add nnkTypeSection.newTree(nnkTypeDef.newTree(objName, newEmptyNode(), objType)).stringify
  result.add ("\n")
  result.add mutatorProcs
  result.add ("\n")
  result.add newTableStarter(node).stringify
  for field, typ, off, slo, size, child in node.fieldTypeSlots:
    result.add ("\n")
    if child.kind == nkOpenArray:
      result.add newTableArrayAdder(objName[1].strVal, field, "uoffset", slo).stringify
    else:
      if typ notin BasicNimTypes:
        if typ in toSeq(unions.namesU):
          result.add newTableUnionTypeAdder(objName[1].strVal, field, typ & "Type", slo).stringify
          result.add ("\n")
          # TODO: Consider creating a "type [UnionName] = uoffset" and use that instead of using "uoffset" directly
          result.add newTableUnionAdder(objName[1].strVal, field, "uoffset", slo).stringify
        elif typ in toSeq(enums.names):
          result.add newTableEnumAdder(objName[1].strVal, field, getName(enums, typ).enumType, slo).stringify
        else:
          result.add newTableAdder(objName[1].strVal, field, typ, slo).stringify
      else:
        result.add newTableAdder(objName[1].strVal, field, typ, slo).stringify
  result.add newEnder(node).stringify
  result.add ("\n\n")

proc newEnum(node: Node): seq[string] =
  var objName = ident(node.children[0].children[0].lexeme)

  result.add newEnum(
    name = objName,
    fields = toSeq(node.toEnumFields),
    public = true, pure = true
  ).stringify & "\n\n\n"

proc newUnion(node: Node): seq[string] =
  var
    objName = ident(node.children[0].lexeme & "Type")
    objType = nnkObjectTy.newTree(
      newEmptyNode(),
      nnkOfInherit.newTree(
        ident"FlatObj"
      ),
      newEmptyNode() # objFields
    )

  result.add newEnum(
    name = objName,
    fields = toSeq(node.toUnionFields),
    public = true, pure = true
  ).stringify & "\n\n"

  result.add nnkTypeSection.newTree(
    nnkTypeDef.newTree(
      nnkPostfix.newTree(ident"*", ident(node.children[0].lexeme)),
      newEmptyNode(),
      objType
    )
  ).stringify & "\n\n"


proc newNodeFromFlat(node: Node): seq[string] =
  if node.kind == tkTable:
    tabls.add node
    result = newTable(node)
  elif node.kind == tkStruct:
    structs.add node
    result = newStruct(node)
  elif node.kind == tkEnum:
    enums.add node
    result = newEnum(node)
  elif node.kind == tkunion:
    unions.add node
    result = newUnion(node)
  else:
    quit("ERROR, not supported node type: " & $node.kind & "\n\n")

macro generateCodeImpl*(path, filename, outputDir: static[string]; abs: static[bool]): untyped =
  let
    path = splitFile(path).dir
    resourcepath = path / filename

  var
    file = staticRead(resourcepath)
    lexer: Lexer
    parser: Parser

  lexer.initLexer(file)
  lexer.generate_tokens()

  parser.initParser(lexer.tokens)
  parser.parse()

  var header =
    "import\n  Nimflatbuffers\n\n\n"

  var
    outputFile: string = "output"
    fileContents: string = header
    allNodes: seq[string]
    currentNode: seq[string]
  for node in parser.nodes:
    if node.kind == tkNamespace:
      outputFile = node.lexeme.replace(".", "_") & ".nim"
    else:
      currentNode = newNodeFromFlat(node)
      allNodes.add currentNode
      for str in currentNode:
        fileContents.add(str)

  writeFile(outputFile, fileContents[0..^3])

  if gorgeEx(currentSourcePath() / "../../utils/createDir " & path & "\\" &
             outputDir).exitCode != 0:
    quit("ERROR, COULD NOT CREATE DIRECTORY: " & outputDir & " at " & path)
  if gorgeEx(currentSourcePath() / "../../utils/moveFile " & path & "\\" & outputFile &
             " " & path & "\\" & outputDir & "\\" & outputFile).exitCode != 0:
    quit("ERROR, COULD NOT MOVE FILE: " & outputFile &
         " to " & path & "\\" & outputDir)
  if gorgeEx(currentSourcePath() / "../../utils/copyDir " &
             currentSourcePath() / "../../../nimflatbuffers" & " " &
             path & "\\" & outputDir & "\\" & "nimflatbuffers").exitCode != 0:
    quit("ERROR, COULD COPY DIRECTORY: " & path & "nimflatbuffers" & " to " &
         path & "\\" & outputDir & "\\" & "nimflatbuffers")

  result = parseExpr("import " & path & "\\" & outputDir & "\\" & outputFile[0..^5])
