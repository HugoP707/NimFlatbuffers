import
   Nimflatbuffers/[
      flatn/codegen/Codegen,
      nimflatbuffers/nimflatbuffers
   ]
export builder, table, struct


template generateCode*(file: static[string], outputDir: static[string] = "output", abs: static[bool] = false) =
   generateCodeImpl(instantiationInfo(-1, fullPaths = true).filename, file, outputDir, abs)
