version     = "1.0.0"
author      = "Nimflatbuffers"
description = "A pure nim flatbuffers implementation + .fbs processor macro"
license     = "MIT"

srcDir = "src"

requires "nim >= 1.4.0"

task MonsterTest, "Runs the Monster test":
   exec "nim c -r tests/monster/Monster"

task test1, "Runs the test1":
   exec "nim c -r tests/test1/test1.nim"

task test2, "Runs the test2":
   exec "nim c -r tests/test2/test2.nim"