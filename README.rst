==============
NimFlatbuffers
==============
A pure nim implementation of Flatbuffers + fbs macro file processor.
--------------------------------------------------------------------

I finally wont be using c++ for the code generator, isntead, i used a macro, since it was more fitting, however, the code generator ended up being a bit wonky.

It supports a decent subset of .fbs schema language, from my experience, the most used one.

Full list of features it supports/will support:

=======     ===================
Support           Feature
=======     ===================
DONE        Structs
DONE        Tables
DONE        Unions
TODO        Code reordering
TODO        Strings and vectors
DONE        namespaces
Wont do     Nested namespaces
===============================


\*Strings and vectors are supported in the library, but the generated code does not correctly handle them, changes shouldnt be too hard to make them work though.


Usage
-----

Just import the library and pass the `generateCode` macro a path to the .fbs file.
```nim
import Nimflatbuffers

generateCode("test.fbs")
```

Optionally, pass an output directory name ("./output" by default).
```nim
import Nimflatbuffers

generateCode("test.fbs", "../bin/myOwnOutput")
```