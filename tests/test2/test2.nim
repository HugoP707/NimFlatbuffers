import Nimflatbuffers

generateCode("test2.fbs")
# import output/rlbot_flat # not needed, generatedCode does this

var builder = newBuilder(50)

builder.PlayerInputStart()