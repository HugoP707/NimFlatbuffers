version     = "1.0.0"
author      = "Nimflatbuffers"
description = "A pure nim flatbuffers implementation + .fbs processor macro"
license     = "MIT"

srcDir = "src"

requires "nim >= 1.4.0"

task test, "Runs the test":
   exec "nim check tests/test1"