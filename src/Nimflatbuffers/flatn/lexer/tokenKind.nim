type
  TokenKind* = enum
    tkNone,
    # Literals.
    tkIdentifier,
    tkString,
    tkNumber,
    # Single-character tokens.
    tkLeftParen,
    tkRightParen,
    tkLeftBrace,
    tkRightBrace,
    tkLeftSQBra,
    tkRightSQBra,
    tkComma,
    tkColon,
    tkDot,
    tkSemicolon,
    tkEquals,
    # Keywords.
    tkNamespace,
    tkStruct,
    tkTable,
    tkUnion,
    tkEnum,
    tkFalse,
    tkTrue,
    tkEof,

    nkBraceExpr,
    nkOpenArray


#proc `==`*(a, b: TokenKind): bool = cast[int](a) == cast[int](b)