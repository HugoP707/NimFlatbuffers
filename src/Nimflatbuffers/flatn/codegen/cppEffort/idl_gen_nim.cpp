/*
 * Copyright 2014 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// independent from idl_parser, since this code is not needed for most clients

#include <sstream>
#include <string>

#include "flatbuffers/code_generators.h"
#include "flatbuffers/flatbuffers.h"
#include "flatbuffers/idl.h"
#include "flatbuffers/util.h"

#ifdef _WIN32
#  include <direct.h>
#  define PATH_SEPARATOR "\\"
#  define mkdir(n, m) _mkdir(n)
#else
#  include <sys/stat.h>
#  define PATH_SEPARATOR "/"
#endif

namespace flatbuffers {

namespace go {

// see https://golang.org/ref/spec#Keywords
static const char *const g_golang_keywords[] = {
  "break",  "default", "proc",        "interface", "select", "case", "defer",
  "go",     "map",     "struct",      "chan",      "else",   "goto", "package",
  "switch", "const",   "fallthrough", "if",        "range",  "type", "continue",
  "for",    "import",  "return",      "var",
};

static std::string GoIdentity(const std::string &name) {
  for (size_t i = 0;
       i < sizeof(g_golang_keywords) / sizeof(g_golang_keywords[0]); i++) {
    if (name == g_golang_keywords[i]) { return MakeCamel(name + "_", false); }
  }

  return MakeCamel(name, false);
}

class GoGenerator : public BaseGenerator {
 public:
  GoGenerator(const Parser &parser, const std::string &path,
              const std::string &file_name, const std::string &go_namespace)
      : BaseGenerator(parser, path, file_name, "" /* not used*/,
                      "" /* not used */, "go"),
        cur_name_space_(nullptr) {
    std::istringstream iss(go_namespace);
    std::string component;
    while (std::getline(iss, component, '.')) {
      go_namespace_.components.push_back(component);
    }
  }

  bool generate() {
    std::string one_file_code;
    bool needs_imports = false;
    for (auto it = parser_.enums_.vec.begin(); it != parser_.enums_.vec.end();
         ++it) {
      tracked_imported_namespaces_.clear();
      needs_imports = false;
      std::string enumcode;
      GenEnum(**it, &enumcode);
      if ((*it)->is_union && parser_.opts.generate_object_based_api) {
        GenNativeUnion(**it, &enumcode);
        GenNativeUnionPack(**it, &enumcode);
        GenNativeUnionUnPack(**it, &enumcode);
        needs_imports = true;
      }
      if (parser_.opts.one_file) {
        one_file_code += enumcode;
      } else {
        if (!SaveType(**it, enumcode, needs_imports, true)) return false;
      }
    }

    for (auto it = parser_.structs_.vec.begin();
         it != parser_.structs_.vec.end(); ++it) {
      tracked_imported_namespaces_.clear();
      std::string declcode;
      GenStruct(**it, &declcode);
      if (parser_.opts.one_file) {
        one_file_code += declcode;
      } else {
        if (!SaveType(**it, declcode, true, false)) return false;
      }
    }

    if (parser_.opts.one_file) {
      std::string code = "";
      const bool is_enum = !parser_.enums_.vec.empty();
      BeginFile(LastNamespacePart(go_namespace_), true, is_enum, &code);
      code += one_file_code;
      const std::string filename =
          GeneratedFileName(path_, file_name_, parser_.opts);
      return SaveFile(filename.c_str(), code, false);
    }

    return true;
  }

 private:
  Namespace go_namespace_;
  Namespace *cur_name_space_;

  struct NamespacePtrLess {
    bool operator()(const Namespace *a, const Namespace *b) const {
      return *a < *b;
    }
  };
  std::set<const Namespace *, NamespacePtrLess> tracked_imported_namespaces_;

  // Most field accessors need to retrieve and test the field offset first,
  // this is the prefix code for that.
  std::string OffsetPrefix(const FieldDef &field) {
    return "{\n  o := uoffset(rcv._tab.Offset(" +
           NumToString(field.value.offset) + "))\n  if o != 0 {\n";
  }

  // Begin a class declaration.
  void BeginClass(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "type " + struct_def.name + " struct {\n  ";

    // _ is reserved in flatbuffers field names, so no chance of name conflict:
    code += "_tab ";
    code += struct_def.fixed ? "flatbuffers.Struct" : "flatbuffers.Table";
    code += "\n}\n\n";
  }

  // Construct the name of the type for this enum.
  std::string GetEnumTypeName(const EnumDef &enum_def) {
    return WrapInNameSpaceAndTrack(enum_def.defined_namespace,
                                   GoIdentity(enum_def.name));
  }

  // Create a type for the enum values.
  void GenEnumType(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "type " + GetEnumTypeName(enum_def) + " ";
    code += GenTypeBasic(enum_def.underlying_type) + "\n\n";
  }

  // Begin enum code with a class declaration.
  void BeginEnum(std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "const (\n";
  }

  // A single enum member.
  void EnumMember(const EnumDef &enum_def, const EnumVal &ev,
                  size_t max_name_length, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "  ";
    code += enum_def.name;
    code += ev.name;
    code += " ";
    code += std::string(max_name_length - ev.name.length(), ' ');
    code += GetEnumTypeName(enum_def);
    code += " = ";
    code += enum_def.ToString(ev) + "\n";
  }

  // End enum code.
  void EndEnum(std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += ")\n\n";
  }

  // Begin enum name map.
  void BeginEnumNames(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "var EnumNames";
    code += enum_def.name;
    code += " = map[" + GetEnumTypeName(enum_def) + "]string{\n";
  }

  // A single enum name member.
  void EnumNameMember(const EnumDef &enum_def, const EnumVal &ev,
                      size_t max_name_length, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "  ";
    code += enum_def.name;
    code += ev.name;
    code += ": ";
    code += std::string(max_name_length - ev.name.length(), ' ');
    code += "\"";
    code += ev.name;
    code += "\",\n";
  }

  // End enum name map.
  void EndEnumNames(std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "}\n\n";
  }

  // Generate String() method on enum type.
  void EnumStringer(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc (v " + enum_def.name + ") String() string {\n";
    code += "  if s, ok := EnumNames" + enum_def.name + "[v]; ok {\n";
    code += "    return s\n";
    code += "  }\n";
    code += "  return \"" + enum_def.name;
    code += "(\" + strconv.FormatInt(int64(v), 10) + \")\"\n";
    code += "}\n\n";
  }

  // Begin enum value map.
  void BeginEnumValues(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "var EnumValues";
    code += enum_def.name;
    code += " = map[string]" + GetEnumTypeName(enum_def) + "{\n";
  }

  // A single enum value member.
  void EnumValueMember(const EnumDef &enum_def, const EnumVal &ev,
                       size_t max_name_length, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "  \"";
    code += ev.name;
    code += "\": ";
    code += std::string(max_name_length - ev.name.length(), ' ');
    code += enum_def.name;
    code += ev.name;
    code += ",\n";
  }

  // End enum value map.
  void EndEnumValues(std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "}\n\n";
  }

  // Initialize a new struct or table from existing data.
  void NewRootTypeFromBuffer(const StructDef &struct_def,
                             std::string *code_ptr) {
    std::string &code = *code_ptr;
    std::string size_prefix[] = { "", "SizePrefixed" };

    for (int i = 0; i < 2; i++) {
      code += "proc Get" + size_prefix[i] + "RootAs";
      code += struct_def.name;
      code += "(buf []byte, offset uoffset) ";
      code += "*" + struct_def.name + "";
      code += " {\n";
      if (i == 0) {
        code += "  n := flatbuffers.GetUOffsetT(buf[offset:])\n";
      } else {
        code += "  n := flatbuffers.GetUOffsetT(buf[offset+flatbuffers.SizeUint32:])\n";
      }
      code += "  x := &" + struct_def.name + "{}\n";
      if (i == 0) {
        code += "  x.Init(buf, n+offset)\n";
      } else {
        code += "  x.Init(buf, n+offset+flatbuffers.SizeUint32)\n";
      }
      code += "  return x\n";
      code += "}\n\n";
    }
  }

  // Initialize an existing object with other data, to avoid an allocation.
  void InitializeExisting(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    GenReceiver(struct_def, code_ptr);
    code += " Init(buf []byte, i uoffset) ";
    code += "{\n";
    code += "  rcv._tab.Bytes = buf\n";
    code += "  rcv._tab.Pos = i\n";
    code += "}\n\n";
  }

  // Implement the table accessor
  void GenTableAccessor(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    GenReceiver(struct_def, code_ptr);
    code += " Table() flatbuffers.Table ";
    code += "{\n";

    if (struct_def.fixed) {
      code += "  return rcv._tab.Table\n";
    } else {
      code += "  return rcv._tab\n";
    }
    code += "}\n\n";
  }

  // Get the length of a vector.
  void GetVectorLen(const StructDef &struct_def, const FieldDef &field,
                    std::string *code_ptr) {
    std::string &code = *code_ptr;

    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name) + "Length(";
    code += ") int " + OffsetPrefix(field);
    code += "    return rcv._tab.VectorLen(o)\n  }\n";
    code += "  return 0\n}\n\n";
  }

  // Get a [ubyte] vector as a byte slice.
  void GetUByteSlice(const StructDef &struct_def, const FieldDef &field,
                     std::string *code_ptr) {
    std::string &code = *code_ptr;

    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name) + "Bytes(";
    code += ") []byte " + OffsetPrefix(field);
    code += "    return rcv._tab.ByteVector(o + rcv._tab.Pos)\n  }\n";
    code += "  return nil\n}\n\n";
  }

  // Get the value of a struct's scalar.
  void GetScalarFieldOfStruct(const StructDef &struct_def,
                              const FieldDef &field, std::string *code_ptr) {
    std::string &code = *code_ptr;
    std::string getter = GenGetter(field.value.type);
    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "() " + TypeName(field) + " {\n";
    code += "  return " +
            CastToEnum(field.value.type,
                       getter + "(rcv._tab.Pos + uoffset(" +
                           NumToString(field.value.offset) + "))");
    code += "\n}\n";
  }

  // Get the value of a table's scalar.
  void GetScalarFieldOfTable(const StructDef &struct_def, const FieldDef &field,
                             std::string *code_ptr) {
    std::string &code = *code_ptr;
    std::string getter = GenGetter(field.value.type);
    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "() " + TypeName(field) + " ";
    code += OffsetPrefix(field) + "    return ";
    code += CastToEnum(field.value.type, getter + "(o + rcv._tab.Pos)");
    code += "\n  }\n";
    code += "  return " + GenConstant(field) + "\n";
    code += "}\n\n";
  }

  // Get a struct by initializing an existing struct.
  // Specific to Struct.
  void GetStructFieldOfStruct(const StructDef &struct_def,
                              const FieldDef &field, std::string *code_ptr) {
    std::string &code = *code_ptr;
    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "(obj *" + TypeName(field);
    code += ") *" + TypeName(field);
    code += " {\n";
    code += "  if obj == nil {\n";
    code += "    obj = new(" + TypeName(field) + ")\n";
    code += "  }\n";
    code += "  obj.Init(rcv._tab.Bytes, rcv._tab.Pos+";
    code += NumToString(field.value.offset) + ")";
    code += "\n  return obj\n";
    code += "}\n";
  }

  // Get a struct by initializing an existing struct.
  // Specific to Table.
  void GetStructFieldOfTable(const StructDef &struct_def, const FieldDef &field,
                             std::string *code_ptr) {
    std::string &code = *code_ptr;
    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "(obj *";
    code += TypeName(field);
    code += ") *" + TypeName(field) + " " + OffsetPrefix(field);
    if (field.value.type.struct_def->fixed) {
      code += "    x := o + rcv._tab.Pos\n";
    } else {
      code += "    x := rcv._tab.Indirect(o + rcv._tab.Pos)\n";
    }
    code += "    if obj == nil {\n";
    code += "      obj = new(" + TypeName(field) + ")\n";
    code += "    }\n";
    code += "    obj.Init(rcv._tab.Bytes, x)\n";
    code += "    return obj\n  }\n  return nil\n";
    code += "}\n\n";
  }

  // Get the value of a string.
  void GetStringField(const StructDef &struct_def, const FieldDef &field,
                      std::string *code_ptr) {
    std::string &code = *code_ptr;
    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "() " + TypeName(field) + " ";
    code += OffsetPrefix(field) + "    return " + GenGetter(field.value.type);
    code += "(o + rcv._tab.Pos)\n  }\n  return nil\n";
    code += "}\n\n";
  }

  // Get the value of a union from an object.
  void GetUnionField(const StructDef &struct_def, const FieldDef &field,
                     std::string *code_ptr) {
    std::string &code = *code_ptr;
    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name) + "(";
    code += "obj " + GenTypePointer(field.value.type) + ") bool ";
    code += OffsetPrefix(field);
    code += "    " + GenGetter(field.value.type);
    code += "(obj, o)\n    return true\n  }\n";
    code += "  return false\n";
    code += "}\n\n";
  }

  // Get the value of a vector's struct member.
  void GetMemberOfVectorOfStruct(const StructDef &struct_def,
                                 const FieldDef &field, std::string *code_ptr) {
    std::string &code = *code_ptr;
    auto vectortype = field.value.type.VectorType();

    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "(obj *" + TypeName(field);
    code += ", j int) bool " + OffsetPrefix(field);
    code += "    x := rcv._tab.Vector(o)\n";
    code += "    x += uoffset(j) * ";
    code += NumToString(InlineSize(vectortype)) + "\n";
    if (!(vectortype.struct_def->fixed)) {
      code += "    x = rcv._tab.Indirect(x)\n";
    }
    code += "    obj.Init(rcv._tab.Bytes, x)\n";
    code += "    return true\n  }\n";
    code += "  return false\n";
    code += "}\n\n";
  }

  // Get the value of a vector's non-struct member.
  void GetMemberOfVectorOfNonStruct(const StructDef &struct_def,
                                    const FieldDef &field,
                                    std::string *code_ptr) {
    std::string &code = *code_ptr;
    auto vectortype = field.value.type.VectorType();

    GenReceiver(struct_def, code_ptr);
    code += " " + MakeCamel(field.name);
    code += "(j int) " + TypeName(field) + " ";
    code += OffsetPrefix(field);
    code += "    a := rcv._tab.Vector(o)\n";
    code += "    return " +
            CastToEnum(field.value.type,
                       GenGetter(field.value.type) +
                           "(a + uoffset(j*" +
                           NumToString(InlineSize(vectortype)) + "))");
    code += "\n  }\n";
    if (IsString(vectortype)) {
      code += "  return nil\n";
    } else if (vectortype.base_type == BASE_TYPE_BOOL) {
      code += "  return false\n";
    } else {
      code += "  return 0\n";
    }
    code += "}\n\n";
  }

  // Begin the creator proction signature.
  void BeginBuilderArgs(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    if (code.substr(code.length() - 2) != "\n\n") {
      // a previous mutate has not put an extra new line
      code += "\n";
    }
    code += "proc Create" + struct_def.name;
    code += "(builder *flatbuffers.Builder";
  }

  // Recursively generate arguments for a constructor, to deal with nested
  // structs.
  void StructBuilderArgs(const StructDef &struct_def, const char *nameprefix,
                         std::string *code_ptr) {
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      auto &field = **it;
      if (IsStruct(field.value.type)) {
        // Generate arguments for a struct inside a struct. To ensure names
        // don't clash, and to make it obvious these arguments are constructing
        // a nested struct, prefix the name with the field name.
        StructBuilderArgs(*field.value.type.struct_def,
                          (nameprefix + (field.name + "_")).c_str(), code_ptr);
      } else {
        std::string &code = *code_ptr;
        code += std::string(", ") + nameprefix;
        code += GoIdentity(field.name);
        code += " " + TypeName(field);
      }
    }
  }

  // End the creator proction signature.
  void EndBuilderArgs(std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += ") uoffset {\n";
  }

  // Recursively generate struct construction statements and instert manual
  // padding.
  void StructBuilderBody(const StructDef &struct_def, const char *nameprefix,
                         std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "  builder.Prep(" + NumToString(struct_def.minalign) + ", ";
    code += NumToString(struct_def.bytesize) + ")\n";
    for (auto it = struct_def.fields.vec.rbegin();
         it != struct_def.fields.vec.rend(); ++it) {
      auto &field = **it;
      if (field.padding)
        code += "  builder.Pad(" + NumToString(field.padding) + ")\n";
      if (IsStruct(field.value.type)) {
        StructBuilderBody(*field.value.type.struct_def,
                          (nameprefix + (field.name + "_")).c_str(), code_ptr);
      } else {
        code += "  builder.Prepend" + GenMethod(field) + "(";
        code += CastToBaseType(field.value.type,
                               nameprefix + GoIdentity(field.name)) +
                ")\n";
      }
    }
  }

  void EndBuilderBody(std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "  return builder.Offset()\n";
    code += "}\n";
  }

  // Get the value of a table's starting offset.
  void GetStartOfTable(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc " + struct_def.name + "Start";
    code += "(builder *flatbuffers.Builder) {\n";
    code += "  builder.StartObject(";
    code += NumToString(struct_def.fields.vec.size());
    code += ")\n}\n";
  }

  // Set the value of a table's field.
  void BuildFieldOfTable(const StructDef &struct_def, const FieldDef &field,
                         const size_t offset, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc " + struct_def.name + "Add" + MakeCamel(field.name);
    code += "(builder *flatbuffers.Builder, ";
    code += GoIdentity(field.name) + " ";
    if (!IsScalar(field.value.type.base_type) && (!struct_def.fixed)) {
      code += "uoffset";
    } else {
      code += TypeName(field);
    }
    code += ") {\n";
    code += "  builder.Prepend";
    code += GenMethod(field) + "Slot(";
    code += NumToString(offset) + ", ";
    if (!IsScalar(field.value.type.base_type) && (!struct_def.fixed)) {
      code += "uoffset";
      code += "(";
      code += GoIdentity(field.name) + ")";
    } else {
      code += CastToBaseType(field.value.type, GoIdentity(field.name));
    }
    code += ", " + GenConstant(field);
    code += ")\n}\n";
  }

  // Set the value of one of the members of a table's vector.
  void BuildVectorOfTable(const StructDef &struct_def, const FieldDef &field,
                          std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc " + struct_def.name + "Start";
    code += MakeCamel(field.name);
    code += "Vector(builder *flatbuffers.Builder, numElems int) ";
    code += "uoffset {\n  return builder.StartVector(";
    auto vector_type = field.value.type.VectorType();
    auto alignment = InlineAlignment(vector_type);
    auto elem_size = InlineSize(vector_type);
    code += NumToString(elem_size);
    code += ", numElems, " + NumToString(alignment);
    code += ")\n}\n";
  }

  // Get the offset of the end of a table.
  void GetEndOffsetOnTable(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc " + struct_def.name + "End";
    code += "(builder *flatbuffers.Builder) uoffset ";
    code += "{\n  return builder.EndObject()\n}\n";
  }

  // Generate the receiver for proction signatures.
  void GenReceiver(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc (rcv *" + struct_def.name + ")";
  }

  // Generate a struct field getter, conditioned on its child type(s).
  void GenStructAccessor(const StructDef &struct_def, const FieldDef &field,
                         std::string *code_ptr) {
    GenComment(field.doc_comment, code_ptr, nullptr, "");
    if (IsScalar(field.value.type.base_type)) {
      if (struct_def.fixed) {
        GetScalarFieldOfStruct(struct_def, field, code_ptr);
      } else {
        GetScalarFieldOfTable(struct_def, field, code_ptr);
      }
    } else {
      switch (field.value.type.base_type) {
        case BASE_TYPE_STRUCT:
          if (struct_def.fixed) {
            GetStructFieldOfStruct(struct_def, field, code_ptr);
          } else {
            GetStructFieldOfTable(struct_def, field, code_ptr);
          }
          break;
        case BASE_TYPE_STRING:
          GetStringField(struct_def, field, code_ptr);
          break;
        case BASE_TYPE_VECTOR: {
          auto vectortype = field.value.type.VectorType();
          if (vectortype.base_type == BASE_TYPE_STRUCT) {
            GetMemberOfVectorOfStruct(struct_def, field, code_ptr);
          } else {
            GetMemberOfVectorOfNonStruct(struct_def, field, code_ptr);
          }
          break;
        }
        case BASE_TYPE_UNION: GetUnionField(struct_def, field, code_ptr); break;
        default: FLATBUFFERS_ASSERT(0);
      }
    }
    if (IsVector(field.value.type)) {
      GetVectorLen(struct_def, field, code_ptr);
      if (field.value.type.element == BASE_TYPE_UCHAR) {
        GetUByteSlice(struct_def, field, code_ptr);
      }
    }
  }

  // Mutate the value of a struct's scalar.
  void MutateScalarFieldOfStruct(const StructDef &struct_def,
                                 const FieldDef &field, std::string *code_ptr) {
    std::string &code = *code_ptr;
    std::string type = MakeCamel(GenTypeBasic(field.value.type));
    std::string setter = "rcv._tab.Mutate" + type;
    GenReceiver(struct_def, code_ptr);
    code += " Mutate" + MakeCamel(field.name);
    code += "(n " + TypeName(field) + ") bool {\n  return " + setter;
    code += "(rcv._tab.Pos+uoffset(";
    code += NumToString(field.value.offset) + "), ";
    code += CastToBaseType(field.value.type, "n") + ")\n}\n\n";
  }

  // Mutate the value of a table's scalar.
  void MutateScalarFieldOfTable(const StructDef &struct_def,
                                const FieldDef &field, std::string *code_ptr) {
    std::string &code = *code_ptr;
    std::string type = MakeCamel(GenTypeBasic(field.value.type));
    std::string setter = "rcv._tab.Mutate" + type + "Slot";
    GenReceiver(struct_def, code_ptr);
    code += " Mutate" + MakeCamel(field.name);
    code += "(n " + TypeName(field) + ") bool {\n  return ";
    code += setter + "(" + NumToString(field.value.offset) + ", ";
    code += CastToBaseType(field.value.type, "n") + ")\n";
    code += "}\n\n";
  }

  // Mutate an element of a vector of scalars.
  void MutateElementOfVectorOfNonStruct(const StructDef &struct_def,
                                        const FieldDef &field,
                                        std::string *code_ptr) {
    std::string &code = *code_ptr;
    auto vectortype = field.value.type.VectorType();
    std::string type = MakeCamel(GenTypeBasic(vectortype));
    std::string setter = "rcv._tab.Mutate" + type;
    GenReceiver(struct_def, code_ptr);
    code += " Mutate" + MakeCamel(field.name);
    code += "(j int, n " + TypeName(field) + ") bool ";
    code += OffsetPrefix(field);
    code += "    a := rcv._tab.Vector(o)\n";
    code += "    return " + setter + "(";
    code += "a+uoffset(j*";
    code += NumToString(InlineSize(vectortype)) + "), ";
    code += CastToBaseType(vectortype, "n") + ")\n";
    code += "  }\n";
    code += "  return false\n";
    code += "}\n\n";
  }

  // Generate a struct field setter, conditioned on its child type(s).
  void GenStructMutator(const StructDef &struct_def, const FieldDef &field,
                        std::string *code_ptr) {
    GenComment(field.doc_comment, code_ptr, nullptr, "");
    if (IsScalar(field.value.type.base_type)) {
      if (struct_def.fixed) {
        MutateScalarFieldOfStruct(struct_def, field, code_ptr);
      } else {
        MutateScalarFieldOfTable(struct_def, field, code_ptr);
      }
    } else if (IsVector(field.value.type)) {
      if (IsScalar(field.value.type.element)) {
        MutateElementOfVectorOfNonStruct(struct_def, field, code_ptr);
      }
    }
  }

  // Generate table constructors, conditioned on its members' types.
  void GenTableBuilders(const StructDef &struct_def, std::string *code_ptr) {
    GetStartOfTable(struct_def, code_ptr);

    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      auto &field = **it;
      if (field.deprecated) continue;

      auto offset = it - struct_def.fields.vec.begin();
      BuildFieldOfTable(struct_def, field, offset, code_ptr);
      if (IsVector(field.value.type)) {
        BuildVectorOfTable(struct_def, field, code_ptr);
      }
    }

    GetEndOffsetOnTable(struct_def, code_ptr);
  }

  // Generate struct or table methods.
  void GenStruct(const StructDef &struct_def, std::string *code_ptr) {
    if (struct_def.generated) return;

    cur_name_space_ = struct_def.defined_namespace;

    GenComment(struct_def.doc_comment, code_ptr, nullptr);
    if (parser_.opts.generate_object_based_api) {
      GenNativeStruct(struct_def, code_ptr);
    }
    BeginClass(struct_def, code_ptr);
    if (!struct_def.fixed) {
      // Generate a special accessor for the table that has been declared as
      // the root type.
      NewRootTypeFromBuffer(struct_def, code_ptr);
    }
    // Generate the Init method that sets the field in a pre-existing
    // accessor object. This is to allow object reuse.
    InitializeExisting(struct_def, code_ptr);
    // Generate _tab accessor
    GenTableAccessor(struct_def, code_ptr);

    // Generate struct fields accessors
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      auto &field = **it;
      if (field.deprecated) continue;

      GenStructAccessor(struct_def, field, code_ptr);
      GenStructMutator(struct_def, field, code_ptr);
    }

    // Generate builders
    if (struct_def.fixed) {
      // create a struct constructor proction
      GenStructBuilder(struct_def, code_ptr);
    } else {
      // Create a set of proctions that allow table construction.
      GenTableBuilders(struct_def, code_ptr);
    }
  }

  void GenNativeStruct(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "type " + NativeName(struct_def) + " struct {\n";
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      const FieldDef &field = **it;
      if (field.deprecated) continue;
      if (IsScalar(field.value.type.base_type) &&
          field.value.type.enum_def != nullptr &&
          field.value.type.enum_def->is_union)
        continue;
      code += "  " + MakeCamel(field.name) + " " +
              NativeType(field.value.type) + "\n";
    }
    code += "}\n\n";

    if (!struct_def.fixed) {
      GenNativeTablePack(struct_def, code_ptr);
      GenNativeTableUnPack(struct_def, code_ptr);
    } else {
      GenNativeStructPack(struct_def, code_ptr);
      GenNativeStructUnPack(struct_def, code_ptr);
    }
  }

  void GenNativeUnion(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "type " + NativeName(enum_def) + " struct {\n";
    code += "  Type " + enum_def.name + "\n";
    code += "  Value interface{}\n";
    code += "}\n\n";
  }

  void GenNativeUnionPack(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code += "proc (t *" + NativeName(enum_def) +
            ") Pack(builder *flatbuffers.Builder) uoffset {\n";
    code += "  if t == nil {\n    return 0\n  }\n";

    code += "  switch t.Type {\n";
    for (auto it2 = enum_def.Vals().begin(); it2 != enum_def.Vals().end();
         ++it2) {
      const EnumVal &ev = **it2;
      if (ev.IsZero()) continue;
      code += "  case " + enum_def.name + ev.name + ":\n";
      code += "    return t.Value.(" + NativeType(ev.union_type) +
              ").Pack(builder)\n";
    }
    code += "  }\n";
    code += "  return 0\n";
    code += "}\n\n";
  }

  void GenNativeUnionUnPack(const EnumDef &enum_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "proc (rcv " + enum_def.name +
            ") UnPack(table flatbuffers.Table) *" + NativeName(enum_def) +
            " {\n";
    code += "  switch rcv {\n";

    for (auto it2 = enum_def.Vals().begin(); it2 != enum_def.Vals().end();
         ++it2) {
      const EnumVal &ev = **it2;
      if (ev.IsZero()) continue;
      code += "  case " + enum_def.name + ev.name + ":\n";
      code += "    x := " + ev.union_type.struct_def->name + "{_tab: table}\n";

      code += "    return &" +
              WrapInNameSpaceAndTrack(enum_def.defined_namespace,
                                      NativeName(enum_def)) +
              "{ Type: " + enum_def.name + ev.name + ", Value: x.UnPack() }\n";
    }
    code += "  }\n";
    code += "  return nil\n";
    code += "}\n\n";
  }

  void GenNativeTablePack(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "proc (t *" + NativeName(struct_def) +
            ") Pack(builder *flatbuffers.Builder) uoffset {\n";
    code += "  if t == nil { return 0 }\n";
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      const FieldDef &field = **it;
      if (field.deprecated) continue;
      if (IsScalar(field.value.type.base_type)) continue;

      std::string offset = MakeCamel(field.name, false) + "Offset";

      if (IsString(field.value.type)) {
        code += "  " + offset + " := builder.CreateString(t." +
                MakeCamel(field.name) + ")\n";
      } else if (IsVector(field.value.type) &&
                 field.value.type.element == BASE_TYPE_UCHAR &&
                 field.value.type.enum_def == nullptr) {
        code += "  " + offset + " := uoffset(0)\n";
        code += "  if t." + MakeCamel(field.name) + " != nil {\n";
        code += "    " + offset + " = builder.CreateByteString(t." +
                MakeCamel(field.name) + ")\n";
        code += "  }\n";
      } else if (IsVector(field.value.type)) {
        code += "  " + offset + " := uoffset(0)\n";
        code += "  if t." + MakeCamel(field.name) + " != nil {\n";
        std::string length = MakeCamel(field.name, false) + "Length";
        std::string offsets = MakeCamel(field.name, false) + "Offsets";
        code += "    " + length + " := len(t." + MakeCamel(field.name) + ")\n";
        if (field.value.type.element == BASE_TYPE_STRING) {
          code += "    " + offsets + " := make([]uoffset, " +
                  length + ")\n";
          code += "    for j := 0; j < " + length + "; j++ {\n";
          code += "      " + offsets + "[j] = builder.CreateString(t." +
                  MakeCamel(field.name) + "[j])\n";
          code += "    }\n";
        } else if (field.value.type.element == BASE_TYPE_STRUCT &&
                   !field.value.type.struct_def->fixed) {
          code += "    " + offsets + " := make([]uoffset, " +
                  length + ")\n";
          code += "    for j := 0; j < " + length + "; j++ {\n";
          code += "      " + offsets + "[j] = t." + MakeCamel(field.name) +
                  "[j].Pack(builder)\n";
          code += "    }\n";
        }
        code += "    " + struct_def.name + "Start" + MakeCamel(field.name) +
                "Vector(builder, " + length + ")\n";
        code += "    for j := " + length + " - 1; j >= 0; j-- {\n";
        if (IsScalar(field.value.type.element)) {
          code += "      builder.Prepend" +
                  MakeCamel(GenTypeBasic(field.value.type.VectorType())) + "(" +
                  CastToBaseType(field.value.type.VectorType(),
                                 "t." + MakeCamel(field.name) + "[j]") +
                  ")\n";
        } else if (field.value.type.element == BASE_TYPE_STRUCT &&
                   field.value.type.struct_def->fixed) {
          code += "      t." + MakeCamel(field.name) + "[j].Pack(builder)\n";
        } else {
          code += "      builder.PrependUOffsetT(" + offsets + "[j])\n";
        }
        code += "    }\n";
        code += "    " + offset + " = builder.EndVector(" + length + ")\n";
        code += "  }\n";
      } else if (field.value.type.base_type == BASE_TYPE_STRUCT) {
        if (field.value.type.struct_def->fixed) continue;
        code += "  " + offset + " := t." + MakeCamel(field.name) +
                ".Pack(builder)\n";
      } else if (field.value.type.base_type == BASE_TYPE_UNION) {
        code += "  " + offset + " := t." + MakeCamel(field.name) +
                ".Pack(builder)\n";
        code += "  \n";
      } else {
        FLATBUFFERS_ASSERT(0);
      }
    }
    code += "  " + struct_def.name + "Start(builder)\n";
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      const FieldDef &field = **it;
      if (field.deprecated) continue;

      std::string offset = MakeCamel(field.name, false) + "Offset";
      if (IsScalar(field.value.type.base_type)) {
        if (field.value.type.enum_def == nullptr ||
            !field.value.type.enum_def->is_union) {
          code += "  " + struct_def.name + "Add" + MakeCamel(field.name) +
                  "(builder, t." + MakeCamel(field.name) + ")\n";
        }
      } else {
        if (field.value.type.base_type == BASE_TYPE_STRUCT &&
            field.value.type.struct_def->fixed) {
          code += "  " + offset + " := t." + MakeCamel(field.name) +
                  ".Pack(builder)\n";
        } else if (field.value.type.enum_def != nullptr &&
                   field.value.type.enum_def->is_union) {
          code += "  if t." + MakeCamel(field.name) + " != nil {\n";
          code += "    " + struct_def.name + "Add" +
                  MakeCamel(field.name + UnionTypeFieldSuffix()) +
                  "(builder, t." + MakeCamel(field.name) + ".Type)\n";
          code += "  }\n";
        }
        code += "  " + struct_def.name + "Add" + MakeCamel(field.name) +
                "(builder, " + offset + ")\n";
      }
    }
    code += "  return " + struct_def.name + "End(builder)\n";
    code += "}\n\n";
  }

  void GenNativeTableUnPack(const StructDef &struct_def,
                            std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "proc (rcv *" + struct_def.name + ") UnPackTo(t *" +
            NativeName(struct_def) + ") {\n";
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      const FieldDef &field = **it;
      if (field.deprecated) continue;
      std::string field_name_camel = MakeCamel(field.name);
      std::string length = MakeCamel(field.name, false) + "Length";
      if (IsScalar(field.value.type.base_type)) {
        if (field.value.type.enum_def != nullptr &&
            field.value.type.enum_def->is_union)
          continue;
        code +=
            "  t." + field_name_camel + " = rcv." + field_name_camel + "()\n";
      } else if (IsString(field.value.type)) {
        code += "  t." + field_name_camel + " = string(rcv." +
                field_name_camel + "())\n";
      } else if (IsVector(field.value.type) &&
                 field.value.type.element == BASE_TYPE_UCHAR &&
                 field.value.type.enum_def == nullptr) {
        code += "  t." + field_name_camel + " = rcv." + field_name_camel +
                "Bytes()\n";
      } else if (IsVector(field.value.type)) {
        code += "  " + length + " := rcv." + field_name_camel + "Length()\n";
        code += "  t." + field_name_camel + " = make(" +
                NativeType(field.value.type) + ", " + length + ")\n";
        code += "  for j := 0; j < " + length + "; j++ {\n";
        if (field.value.type.element == BASE_TYPE_STRUCT) {
          code += "    x := " + field.value.type.struct_def->name + "{}\n";
          code += "    rcv." + field_name_camel + "(&x, j)\n";
        }
        code += "    t." + field_name_camel + "[j] = ";
        if (IsScalar(field.value.type.element)) {
          code += "rcv." + field_name_camel + "(j)";
        } else if (field.value.type.element == BASE_TYPE_STRING) {
          code += "string(rcv." + field_name_camel + "(j))";
        } else if (field.value.type.element == BASE_TYPE_STRUCT) {
          code += "x.UnPack()";
        } else {
          // TODO(iceboy): Support vector of unions.
          FLATBUFFERS_ASSERT(0);
        }
        code += "\n";
        code += "  }\n";
      } else if (field.value.type.base_type == BASE_TYPE_STRUCT) {
        code += "  t." + field_name_camel + " = rcv." + field_name_camel +
                "(nil).UnPack()\n";
      } else if (field.value.type.base_type == BASE_TYPE_UNION) {
        std::string field_table = MakeCamel(field.name, false) + "Table";
        code += "  " + field_table + " := flatbuffers.Table{}\n";
        code +=
            "  if rcv." + MakeCamel(field.name) + "(&" + field_table + ") {\n";
        code += "    t." + field_name_camel + " = rcv." +
                MakeCamel(field.name + UnionTypeFieldSuffix()) + "().UnPack(" +
                field_table + ")\n";
        code += "  }\n";
      } else {
        FLATBUFFERS_ASSERT(0);
      }
    }
    code += "}\n\n";

    code += "proc (rcv *" + struct_def.name + ") UnPack() *" +
            NativeName(struct_def) + " {\n";
    code += "  if rcv == nil { return nil }\n";
    code += "  t := &" + NativeName(struct_def) + "{}\n";
    code += "  rcv.UnPackTo(t)\n";
    code += "  return t\n";
    code += "}\n\n";
  }

  void GenNativeStructPack(const StructDef &struct_def, std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "proc (t *" + NativeName(struct_def) +
            ") Pack(builder *flatbuffers.Builder): uoffset {\n";
    code += "  if t == nil { return 0 }\n";
    code += "  return Create" + struct_def.name + "(builder";
    StructPackArgs(struct_def, "", code_ptr);
    code += ")\n";
    code += "}\n";
  }

  void StructPackArgs(const StructDef &struct_def, const char *nameprefix,
                      std::string *code_ptr) {
    std::string &code = *code_ptr;
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      const FieldDef &field = **it;
      if (field.value.type.base_type == BASE_TYPE_STRUCT) {
        StructPackArgs(*field.value.type.struct_def,
                       (nameprefix + MakeCamel(field.name) + ".").c_str(),
                       code_ptr);
      } else {
        code += std::string(", t.") + nameprefix + MakeCamel(field.name);
      }
    }
  }

  void GenNativeStructUnPack(const StructDef &struct_def,
                             std::string *code_ptr) {
    std::string &code = *code_ptr;

    code += "proc (rcv *" + struct_def.name + ") UnPackTo(t *" +
            NativeName(struct_def) + ") {\n";
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      const FieldDef &field = **it;
      if (field.value.type.base_type == BASE_TYPE_STRUCT) {
        code += "  t." + MakeCamel(field.name) + " = rcv." +
                MakeCamel(field.name) + "(nil).UnPack()\n";
      } else {
        code += "  t." + MakeCamel(field.name) + " = rcv." +
                MakeCamel(field.name) + "()\n";
      }
    }
    code += "}\n\n";

    code += "proc (rcv *" + struct_def.name + ") UnPack() *" +
            NativeName(struct_def) + " {\n";
    code += "  if rcv == nil { return nil }\n";
    code += "  t := &" + NativeName(struct_def) + "{}\n";
    code += "  rcv.UnPackTo(t)\n";
    code += "  return t\n";
    code += "}\n\n";
  }

  // Generate enum declarations.
  void GenEnum(const EnumDef &enum_def, std::string *code_ptr) {
    if (enum_def.generated) return;

    auto max_name_length = MaxNameLength(enum_def);
    cur_name_space_ = enum_def.defined_namespace;

    GenComment(enum_def.doc_comment, code_ptr, nullptr);
    GenEnumType(enum_def, code_ptr);
    BeginEnum(code_ptr);
    for (auto it = enum_def.Vals().begin(); it != enum_def.Vals().end(); ++it) {
      const EnumVal &ev = **it;
      GenComment(ev.doc_comment, code_ptr, nullptr, "  ");
      EnumMember(enum_def, ev, max_name_length, code_ptr);
    }
    EndEnum(code_ptr);

    BeginEnumNames(enum_def, code_ptr);
    for (auto it = enum_def.Vals().begin(); it != enum_def.Vals().end(); ++it) {
      const EnumVal &ev = **it;
      EnumNameMember(enum_def, ev, max_name_length, code_ptr);
    }
    EndEnumNames(code_ptr);

    BeginEnumValues(enum_def, code_ptr);
    for (auto it = enum_def.Vals().begin(); it != enum_def.Vals().end(); ++it) {
      auto &ev = **it;
      EnumValueMember(enum_def, ev, max_name_length, code_ptr);
    }
    EndEnumValues(code_ptr);

    EnumStringer(enum_def, code_ptr);
  }

  // Returns the proction name that is able to read a value of the given type.
  std::string GenGetter(const Type &type) {
    switch (type.base_type) {
      case BASE_TYPE_STRING: return "rcv.tab.ByteVector";
      case BASE_TYPE_UNION: return "rcv.tab.Union";
      case BASE_TYPE_VECTOR: return GenGetter(type.VectorType());
      default: return "rcv.tab.Get[" + GenTypeBasic(type);
    }
  }

  // Returns the method name for use with add/put calls.
  std::string GenMethod(const FieldDef &field) {
    return IsScalar(field.value.type.base_type)
               ? MakeCamel(GenTypeBasic(field.value.type))
               : (IsStruct(field.value.type) ? "Struct" : "UOffsetT");
  }

  std::string GenTypeBasic(const Type &type) {
    // clang-format off
    static const char *ctypename[] = {
      #define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, JTYPE, GTYPE, ...) \
        #GTYPE,
        FLATBUFFERS_GEN_TYPES(FLATBUFFERS_TD)
      #undef FLATBUFFERS_TD
    };
    // clang-format on
    return ctypename[type.base_type];
  }

  std::string GenTypePointer(const Type &type) {
    switch (type.base_type) {
      case BASE_TYPE_STRING: return "seq[byte]";
      case BASE_TYPE_VECTOR: return GenTypeGet(type.VectorType());
      case BASE_TYPE_STRUCT: return WrapInNameSpaceAndTrack(*type.struct_def);
      case BASE_TYPE_UNION:
        // fall through
      default: return "var Vtable";
    }
  }

  std::string GenTypeGet(const Type &type) {
    if (type.enum_def != nullptr) { return GetEnumTypeName(*type.enum_def); }
    return IsScalar(type.base_type) ? GenTypeBasic(type) : GenTypePointer(type);
  }

  std::string TypeName(const FieldDef &field) {
    return GenTypeGet(field.value.type);
  }

  // If type is an enum, returns value with a cast to the enum type, otherwise
  // returns value as-is.
  std::string CastToEnum(const Type &type, std::string value) {
    if (type.enum_def == nullptr) {
      return value;
    } else {
      return GenTypeGet(type) + "(" + value + ")";
    }
  }

  // If type is an enum, returns value with a cast to the enum base type,
  // otherwise returns value as-is.
  std::string CastToBaseType(const Type &type, std::string value) {
    if (type.enum_def == nullptr) {
      return value;
    } else {
      return GenTypeBasic(type) + "(" + value + ")";
    }
  }

  std::string GenConstant(const FieldDef &field) {
    switch (field.value.type.base_type) {
      case BASE_TYPE_BOOL:
        return field.value.constant == "0" ? "false" : "true";
      default: return field.value.constant;
    }
  }

  std::string NativeName(const StructDef &struct_def) {
    return parser_.opts.object_prefix + struct_def.name +
           parser_.opts.object_suffix;
  }

  std::string NativeName(const EnumDef &enum_def) {
    return parser_.opts.object_prefix + enum_def.name +
           parser_.opts.object_suffix;
  }

  std::string NativeType(const Type &type) {
    if (IsScalar(type.base_type)) {
      if (type.enum_def == nullptr) {
        return GenTypeBasic(type);
      } else {
        return GetEnumTypeName(*type.enum_def);
      }
    } else if (IsString(type)) {
      return "string";
    } else if (IsVector(type)) {
      return "[]" + NativeType(type.VectorType());
    } else if (type.base_type == BASE_TYPE_STRUCT) {
      return "*" + WrapInNameSpaceAndTrack(type.struct_def->defined_namespace,
                                           NativeName(*type.struct_def));
    } else if (type.base_type == BASE_TYPE_UNION) {
      return "*" + WrapInNameSpaceAndTrack(type.enum_def->defined_namespace,
                                           NativeName(*type.enum_def));
    }
    FLATBUFFERS_ASSERT(0);
    return std::string();
  }

  // Create a struct with a builder and the struct's arguments.
  void GenStructBuilder(const StructDef &struct_def, std::string *code_ptr) {
    BeginBuilderArgs(struct_def, code_ptr);
    StructBuilderArgs(struct_def, "", code_ptr);
    EndBuilderArgs(code_ptr);

    StructBuilderBody(struct_def, "", code_ptr);
    EndBuilderBody(code_ptr);
  }
  // Begin by declaring namespace and imports.
  void BeginFile(const std::string &name_space_name, const bool needs_imports,
                 const bool is_enum, std::string *code_ptr) {
    std::string &code = *code_ptr;
    code = code +
           "// Code generated by the FlatBuffers compiler. DO NOT EDIT.\n\n";
    code += "package " + name_space_name + "\n\n";
    if (needs_imports) {
      code += "import (\n";
      if (is_enum) { code += "  \"strconv\"\n\n"; }
      if (!parser_.opts.go_import.empty()) {
        code += "  flatbuffers \"" + parser_.opts.go_import + "\"\n";
      } else {
        code += "  flatbuffers \"github.com/google/flatbuffers/go\"\n";
      }
      if (tracked_imported_namespaces_.size() > 0) {
        code += "\n";
        for (auto it = tracked_imported_namespaces_.begin();
             it != tracked_imported_namespaces_.end(); ++it) {
          code += "  " + NamespaceImportName(*it) + " \"" +
                  NamespaceImportPath(*it) + "\"\n";
        }
      }
      code += ")\n\n";
    } else {
      if (is_enum) { code += "import \"strconv\"\n\n"; }
    }
  }

  // Save out the generated code for a Go Table type.
  bool SaveType(const Definition &def, const std::string &classcode,
                const bool needs_imports, const bool is_enum) {
    if (!classcode.length()) return true;

    Namespace &ns = go_namespace_.components.empty() ? *def.defined_namespace
                                                     : go_namespace_;
    std::string code = "";
    BeginFile(LastNamespacePart(ns), needs_imports, is_enum, &code);
    code += classcode;
    // Strip extra newlines at end of file to make it gofmt-clean.
    while (code.length() > 2 && code.substr(code.length() - 2) == "\n\n") {
      code.pop_back();
    }
    std::string filename = NamespaceDir(ns) + def.name + ".go";
    return SaveFile(filename.c_str(), code, false);
  }

  // Create the full name of the imported namespace (format: A__B__C).
  std::string NamespaceImportName(const Namespace *ns) {
    std::string s = "";
    for (auto it = ns->components.begin(); it != ns->components.end(); ++it) {
      if (s.size() == 0) {
        s += *it;
      } else {
        s += "__" + *it;
      }
    }
    return s;
  }

  // Create the full path for the imported namespace (format: A/B/C).
  std::string NamespaceImportPath(const Namespace *ns) {
    std::string s = "";
    for (auto it = ns->components.begin(); it != ns->components.end(); ++it) {
      if (s.size() == 0) {
        s += *it;
      } else {
        s += "/" + *it;
      }
    }
    return s;
  }

  // Ensure that a type is prefixed with its go package import name if it is
  // used outside of its namespace.
  std::string WrapInNameSpaceAndTrack(const Namespace *ns,
                                      const std::string &name) {
    if (CurrentNameSpace() == ns) return name;

    tracked_imported_namespaces_.insert(ns);

    std::string import_name = NamespaceImportName(ns);
    return import_name + "." + name;
  }

  std::string WrapInNameSpaceAndTrack(const Definition &def) {
    return WrapInNameSpaceAndTrack(def.defined_namespace, def.name);
  }

  const Namespace *CurrentNameSpace() const { return cur_name_space_; }

  static size_t MaxNameLength(const EnumDef &enum_def) {
    size_t max = 0;
    for (auto it = enum_def.Vals().begin(); it != enum_def.Vals().end(); ++it) {
      max = std::max((*it)->name.length(), max);
    }
    return max;
  }
};
}  // namespace go

bool GenerateGo(const Parser &parser, const std::string &path,
                const std::string &file_name) {
  go::GoGenerator generator(parser, path, file_name, parser.opts.go_namespace);
  return generator.generate();
}

}  // namespace flatbuffers