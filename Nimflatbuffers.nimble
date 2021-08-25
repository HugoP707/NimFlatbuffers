version     = "1.0.0"
author      = "Nimflatbuffers"
description = "A pure nim flatbuffers implementation + .fbs processor macro"
license     = "MIT"

srcDir = "src"

requires "nim >= 1.4.0"

task MonsterTest, "Runs the Monster test":
   exec "nim c -r tests/Monster"