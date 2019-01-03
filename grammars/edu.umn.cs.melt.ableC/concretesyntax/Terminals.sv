grammar edu:umn:cs:melt:ableC:concretesyntax;

{- The prefix seperator indicates a string that is written between
   transparent prefixes and the following marking terminal that has a
   lexical ambiguity with another extension.  This is used in
   generating the regular expression for the transparent prefix
   terminal symbols that are generated by the parser specifiation.

   We choose "::" becuase it is the same as the C++ scope operator and
   therefor may be more familiar to some users.  Previously this was
   ":", but the single colon is Silver's grammar separator and we
   should pick a prefix separator that is driven by syntax in object
   language (here, C) and not on Silver's syntax.
-}
prefix separator "::";

{--
 - Largely exists to permit embedding into other languages. Allows easy
 - dominates relationship
 -}

temp_imp_ide_font font_all color(160, 32, 240) bold;
temp_imp_ide_font font_type color(34, 139, 34) bold;
temp_imp_ide_font font_string color(139, 34, 82) italic;
temp_imp_ide_font font_comments color(178, 34, 34) italic;
temp_imp_ide_font font_special_symbol color(71, 71, 141);
temp_imp_ide_font font_equal color(71, 71, 141) bold;


lexer class Ccomment font = font_comments;
lexer class Ckeyword font = font_all;
lexer class Ctype font = font_type;
lexer class Cstring font = font_string;
lexer class Cassignment font = font_equal;
lexer class Csymbol font = font_special_symbol;


--

ignore terminal LineComment
  /[\/][\/].*/ 
  lexer classes {Ccomment};

ignore terminal BlockComment 
  /[\/][\*]([^\*]|[\r\n]|([\*]+([^\*\/]|[\r\n])))*[\*]+[\/]/ 
  lexer classes {Ccomment};

{-
ignore terminal WhiteSpace
  /[\n\r\t\ ]+/ 
  lexer classes {Ccomment};
-}

-- The following need to be separated for tables without white space
-- to work.  See edu:umn:cs:melt:exts:ableC:tablesWS.
ignore terminal Spaces_t 
  /[\t\ ]+/ 
  lexer classes {Ccomment};

ignore terminal NewLine_t /[\n\r]+/ 
  lexer classes {Ccomment};

{--
 - Identifiers: normal or type name.
 -}

terminal Identifier_t /[A-Za-z_\$][A-Za-z_0-9\$]*/ lexer classes {Cidentifier};
terminal TypeName_t   /[A-Za-z_\$][A-Za-z_0-9\$]*/ lexer classes {Cidentifier, Ctype};
-- See LexerHack.sv for code related to disambiguation of these terminals.


{--
 - Literals
 -}
lexer class Cliteral;

terminal DecConstant_t /
	((0)|([1-9][0-9]*)) -- Begins with 1-9 or is just 0 alone
	/ lexer classes {Cliteral};
terminal DecConstantU_t   /((0)|([1-9][0-9]*))([Uu])/ lexer classes {Cliteral};
terminal DecConstantL_t   /((0)|([1-9][0-9]*))([Ll])/ lexer classes {Cliteral};
terminal DecConstantUL_t  /((0)|([1-9][0-9]*))(([Uu][Ll])|([Ll][Uu]))/ lexer classes {Cliteral};
terminal DecConstantLL_t  /((0)|([1-9][0-9]*))([Ll][Ll])/ lexer classes {Cliteral};
terminal DecConstantULL_t /((0)|([1-9][0-9]*))(([Uu][Ll][Ll])|([Ll][Ll][Uu]))/ lexer classes {Cliteral};

terminal OctConstant_t /
	(0[0-7]+)           -- Begins with 0 AND has more digits
	/ lexer classes {Cliteral};
terminal OctConstantU_t   /(0[0-7]+)([Uu])/ lexer classes {Cliteral};
terminal OctConstantL_t   /(0[0-7]+)([Ll])/ lexer classes {Cliteral};
terminal OctConstantUL_t  /(0[0-7]+)(([Uu][Ll])|([Ll][Uu]))/ lexer classes {Cliteral};
terminal OctConstantLL_t  /(0[0-7]+)([Ll][Ll])/ lexer classes {Cliteral};
terminal OctConstantULL_t /(0[0-7]+)(([Uu][Ll][Ll])|([Ll][Ll][Uu]))/ lexer classes {Cliteral};
-- Specially recognize octal constants with 8 or 9 in them. (n.b. submits to, not class literal)
terminal OctConstantError_t /(0[0-9]+)[uUlL]*/ submits to {Cliteral};

terminal HexConstant_t /
	(0[xX][0-9A-Fa-f]+) -- Begins with 0x and has more digits
	/ lexer classes {Cliteral};
terminal HexConstantU_t /(0[xX][0-9A-Fa-f]+)([Uu])/ lexer classes {Cliteral};
terminal HexConstantL_t /(0[xX][0-9A-Fa-f]+)([Ll])/ lexer classes {Cliteral};
terminal HexConstantUL_t /(0[xX][0-9A-Fa-f]+)(([Uu][Ll])|([Ll][Uu]))/ lexer classes {Cliteral};
terminal HexConstantLL_t /(0[xX][0-9A-Fa-f]+)([Ll][Ll])/ lexer classes {Cliteral};
terminal HexConstantULL_t /(0[xX][0-9A-Fa-f]+)(([Uu][Ll][Ll])|([Ll][Ll][Uu]))/ lexer classes {Cliteral};

terminal FloatConstant_t /
	(((([0-9]+[\.])|         -- end with do
	  ([0-9]*[\.][0-9]+))    -- has dot
	 ([Ee][\+\-]?[0-9]+)?)|  -- optional exponent
	 ([0-9]+[Ee][\+\-]?[0-9]+)) -- No dot, mandatory exponent
	/ lexer classes {Cliteral};
terminal FloatConstantFloat_t /
	(((([0-9]+[\.])|         -- end with do
	  ([0-9]*[\.][0-9]+))    -- has dot
	 ([Ee][\+\-]?[0-9]+)?)|  -- optional exponent
	 ([0-9]+[Ee][\+\-]?[0-9]+)) -- No dot, mandatory exponent
	[Ff]
	/ lexer classes {Cliteral};
terminal FloatConstantLongDouble_t /
	(((([0-9]+[\.])|         -- end with do
	  ([0-9]*[\.][0-9]+))    -- has dot
	 ([Ee][\+\-]?[0-9]+)?)|  -- optional exponent
	 ([0-9]+[Ee][\+\-]?[0-9]+)) -- No dot, mandatory exponent
	[Ll]
	/ lexer classes {Cliteral};

terminal HexFloatConstant_t /
	0[xX]
	(([a-fA-F0-9]+[\.]?)|
	 ([a-fA-F0-9]*[\.][a-fA-F0-9]+))
	([Pp][\+\-]?[0-9]+) -- mandatory exponent part
	/ lexer classes {Cliteral};
terminal HexFloatConstantFloat_t /
	0[xX]
	(([a-fA-F0-9]+[\.]?)|
	 ([a-fA-F0-9]*[\.][a-fA-F0-9]+))
	([Pp][\+\-]?[0-9]+) -- mandatory exponent part
	[Ff]
	/ lexer classes {Cliteral};
terminal HexFloatConstantLongDouble_t /
	0[xX]
	(([a-fA-F0-9]+[\.]?)|
	 ([a-fA-F0-9]*[\.][a-fA-F0-9]+))
	([Pp][\+\-]?[0-9]+) -- mandatory exponent part
	[Ll]
	/ lexer classes {Cliteral};

terminal StringConstant_t      /[\"]([^\"\\]|[\\].)*[\"]/ lexer classes {Cstring, Cliteral};
terminal StringConstantU8_t  /u8[\"]([^\"\\]|[\\].)*[\"]/ lexer classes {Cstring, Cliteral};
terminal StringConstantL_t    /L[\"]([^\"\\]|[\\].)*[\"]/ lexer classes {Cstring, Cliteral};
terminal StringConstantU_t    /u[\"]([^\"\\]|[\\].)*[\"]/ lexer classes {Cstring, Cliteral};
terminal StringConstantUBig_t /U[\"]([^\"\\]|[\\].)*[\"]/ lexer classes {Cstring, Cliteral};

terminal CharConstant_t      /[\']([^\']|[\\].)[\']/ lexer classes {Cstring, Cliteral};
terminal CharConstantL_t    /L[\']([^\']|[\\].)[\']/ lexer classes {Cstring, Cliteral};
terminal CharConstantU_t    /u[\']([^\']|[\\].)[\']/ lexer classes {Cstring, Cliteral};
terminal CharConstantUBig_t /U[\']([^\']|[\\].)[\']/ lexer classes {Cstring, Cliteral};


{--
 - Keywords
 -}


-- types
terminal Char_t     'char'     lexer classes {Ctype, Ckeyword};
terminal Double_t   'double'   lexer classes {Ctype, Ckeyword};
terminal Float_t    'float'    lexer classes {Ctype, Ckeyword};
terminal Int_t      'int'      lexer classes {Ctype, Ckeyword};
terminal Long_t     'long'     lexer classes {Ctype, Ckeyword};
terminal Short_t    'short'    lexer classes {Ctype, Ckeyword};
terminal Signed_t   'signed'   lexer classes {Ctype, Ckeyword};
terminal Unsigned_t 'unsigned' lexer classes {Ctype, Ckeyword};
terminal Void_t     'void'     lexer classes {Ctype, Ckeyword};
terminal Bool_t     '_Bool'      lexer classes {Ctype, Ckeyword}; -- c99
terminal Complex_t  '_Complex'   lexer classes {Ctype, Ckeyword}; -- c99
terminal Imagin_t   '_Imaginary' lexer classes {Ctype, Ckeyword}; -- c99

-- Er, Specifiers?
terminal ENUM   'enum'   lexer classes {Ckeyword};
terminal STRUCT 'struct' lexer classes {Ckeyword};
terminal UNION  'union'  lexer classes {Ckeyword};

-- Qualifiers
terminal Const_t    'const'    lexer classes {Ckeyword};
terminal Volatile_t 'volatile' lexer classes {Ckeyword};
terminal Restrict_t 'restrict' lexer classes {Ckeyword}; -- c99

-- Function specifiers
terminal Inline_t   'inline'   lexer classes {Ckeyword}; -- c99

-- Storage class specifiers
terminal Auto_t     'auto'     lexer classes {Ckeyword};
terminal Extern_t   'extern'   lexer classes {Ckeyword};
terminal Register_t 'register' lexer classes {Ckeyword};
terminal Static_t   'static'   lexer classes {Ckeyword};
terminal Typedef_t  'typedef'  lexer classes {Ckeyword};

-- Statement keywords
terminal BREAK    'break'    lexer classes {Ckeyword};
terminal CASE     'case'     lexer classes {Ckeyword};
terminal CONTINUE 'continue' lexer classes {Ckeyword};
terminal DEFAULT  'default'  lexer classes {Ckeyword};
terminal DO       'do'       lexer classes {Ckeyword};
terminal ELSE     'else'     lexer classes {Ckeyword}, precedence = 2, association = left;
terminal FOR      'for'      lexer classes {Ckeyword};
terminal GOTO     'goto'     lexer classes {Ckeyword};
terminal IF       'if'       lexer classes {Ckeyword};
terminal Return_t 'return'   lexer classes {Ckeyword};
terminal SWITCH   'switch'   lexer classes {Ckeyword};
terminal WHILE    'while'    lexer classes {Ckeyword};

-- Expression keywords
terminal SIZEOF   'sizeof'   lexer classes {Ckeyword};

-- Structural symbols
terminal Comma_t       ',';
terminal Semi_t        ';';
terminal LParen_t      '(';
terminal RParen_t      ')' precedence = 1, association = left; -- evidently, part of dangling-else?
terminal LBracket_t    '[';
terminal RBracket_t    ']';
terminal LCurly_t      '{'  action { context = head(context) :: context; };
terminal RCurly_t      '}'  action { context = tail(context); };

terminal Question_t    '?';
terminal Colon_t       ':';

-- Dereference operators
terminal Dot_t         '.';
terminal PTR_OP        '->';

-- Assignment operators
terminal Assign_t      '='    lexer classes {Cassignment};
terminal RIGHT_ASSIGN  '>>='    lexer classes {Cassignment}; 
terminal LEFT_ASSIGN   '<<='    lexer classes {Cassignment};
terminal ADD_ASSIGN    '+='    lexer classes {Cassignment};
terminal SUB_ASSIGN    '-='    lexer classes {Cassignment};
terminal MUL_ASSIGN    '*='    lexer classes {Cassignment};
terminal DIV_ASSIGN    '/='    lexer classes {Cassignment};
terminal MOD_ASSIGN    '%='    lexer classes {Cassignment};
terminal AND_ASSIGN    '&='    lexer classes {Cassignment};
terminal XOR_ASSIGN    '^='    lexer classes {Cassignment};
terminal OR_ASSIGN     '|='    lexer classes {Cassignment};

-- Bit operators
terminal And_t         '&'    lexer classes {Csymbol}; -- address of
terminal Or_t          '|'    lexer classes {Csymbol};
terminal Tilde_t       '~'    lexer classes {Csymbol};
terminal Xor_t         '^'    lexer classes {Csymbol};
terminal RIGHT_OP      '>>'    lexer classes {Csymbol};
terminal LEFT_OP       '<<'    lexer classes {Csymbol};

-- Numerical operators
terminal Minus_t       '-'  precedence = 5, association = left, lexer classes {Csymbol}; -- negative
terminal Plus_t        '+'  precedence = 5, association = left,  lexer classes {Csymbol}; -- positive
terminal Star_t        '*'  precedence = 6, association = left, lexer classes {Csymbol}; -- pointer, deref
terminal Divide_t      '/'  precedence = 6, association = left, lexer classes {Csymbol};
terminal Mod_t         '%';

-- Logical operators
terminal Not_t   '!';
terminal AndOp_t '&&' precedence = 4, association = left, lexer classes {Csymbol};
terminal OrOp_t  '||' precedence = 4, association = left, lexer classes {Csymbol};

-- Comparison operators
terminal LessThan_t         '<'  precedence = 3, association = left, lexer classes {Csymbol};
terminal GreaterThan_t      '>'  precedence = 3, association = left, lexer classes {Csymbol};
terminal LessThanEqual_t    '<=' precedence = 3, association = left, lexer classes {Csymbol};
terminal GreaterThanEqual_t '>=' precedence = 3, association = left, lexer classes {Csymbol};
terminal Equality_t         '==' precedence = 3, association = left, lexer classes {Csymbol};
terminal NonEquality_t      '!=' precedence = 3, association = left, lexer classes {Csymbol};

-- *crement operators
terminal INC_OP        '++'    lexer classes {Csymbol};
terminal DEC_OP        '--'    lexer classes {Csymbol};

-- Varargs syntax
terminal ELLIPSES      '...'    lexer classes {Csymbol};

-- High precedence empty terminal, for some reason?
terminal Cpp_Attribute_high_prec '' precedence = 20;

-- Wrappers for identifiers, as extensions may wish to introduce new syntax
-- representing an arbitrary Name
closed nonterminal Identifier_c with location, ast<ast:Name>;
concrete productions top::Identifier_c
| id::Identifier_t
    { top.ast = ast:fromId(id); }

closed nonterminal TypeIdName_c with location, ast<ast:Name>;
concrete productions top::TypeIdName_c
| t::TypeName_t
    { top.ast = ast:fromTy(t); }

-- Seed follow set with additional terminals useful for extensions
-- We include < here since it is allowed in C++
terminal TypeIdName_NEVER_t 'TypeIdName_Never!!!nevernever1234567890';
concrete productions top::Expr_c
| 'TypeIdName_Never!!!nevernever1234567890' TypeIdName_c '<'
    { top.ast = ast:errorExpr ( [ err (top.location, "Internal Error. " ++
        "Placeholder for TypeIdName_c should not appear in the tree.") ],
        location=top.location ) ; }
