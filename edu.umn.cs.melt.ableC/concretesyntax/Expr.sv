grammar edu:umn:cs:melt:ableC:concretesyntax;

import edu:umn:cs:melt:ableC:abstractsyntax:env only env;
import edu:umn:cs:melt:ableC:abstractsyntax:overloadable as ovrld;
-- "Exported" nonterminals

closed nonterminal Expr_c with location, ast<ast:Expr>; 
concrete productions top::Expr_c
| e::AssignExpr_c
    { top.ast = e.ast; }
| l::AssignExpr_c ',' r::Expr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:commaOp(location=$2.location), r.ast, location=top.location); }


closed nonterminal AssignExpr_c with location, ast<ast:Expr>, directName; 
aspect default production
top::AssignExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::AssignExpr_c
| e::ConditionalExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::UnaryExpr_c op::AssignOp_c  r::AssignExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:assignOp(op.ast, location=op.location), r.ast, location=top.location); }


closed nonterminal ConstantExpr_c with location, ast<ast:Expr>;
concrete productions top::ConstantExpr_c
| e::ConditionalExpr_c
    { top.ast = e.ast; }


closed nonterminal Initializer_c with location, ast<ast:Initializer>; 
concrete productions top::Initializer_c
| e::AssignExpr_c
    { top.ast = ast:exprInitializer(e.ast); }
| '{' il::InitializerList_c '}'
    { top.ast = ast:objectInitializer(ast:foldInit(il.ast)); }
| '{' il::InitializerList_c ',' '}' 
    { top.ast = ast:objectInitializer(ast:foldInit(il.ast)); }


-- "Non-exported" nonterminals


closed nonterminal AssignOp_c with location, ast<ast:AssignOp>;
concrete productions top::AssignOp_c
| '='   { top.ast = ast:eqOp(location=top.location); }
| '*='  { top.ast = ast:mulEqOp(location=top.location); }
| '/='  { top.ast = ast:divEqOp(location=top.location); }
| '%='  { top.ast = ast:modEqOp(location=top.location); }
| '+='  { top.ast = ast:addEqOp(location=top.location); }
| '-='  { top.ast = ast:subEqOp(location=top.location); }
| '<<=' { top.ast = ast:lshEqOp(location=top.location); }
| '>>=' { top.ast = ast:rshEqOp(location=top.location); }
| '&='  { top.ast = ast:andEqOp(location=top.location); }
| '^='  { top.ast = ast:xorEqOp(location=top.location); }
| '|='  { top.ast = ast:orEqOp(location=top.location); }


closed nonterminal ConditionalExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::ConditionalExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::ConditionalExpr_c
| ce::LogicalOrExpr_c  '?' te::Expr_c  ':'  ee::ConditionalExpr_c
    { top.ast = ast:conditionalExpr(ce.ast, te.ast, ee.ast, location=top.location); }
| e::LogicalOrExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }


closed nonterminal LogicalOrExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::LogicalOrExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::LogicalOrExpr_c
| e::LogicalAndExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::LogicalOrExpr_c '||' r::LogicalAndExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:boolOp(ast:orBoolOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal LogicalAndExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::LogicalAndExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::LogicalAndExpr_c
| e::InclusiveOrExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::LogicalAndExpr_c '&&' r::InclusiveOrExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:boolOp(ast:andBoolOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal InclusiveOrExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::InclusiveOrExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::InclusiveOrExpr_c
| e::ExclusiveOrExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::InclusiveOrExpr_c '|' r::ExclusiveOrExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:bitOp(ast:orBitOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal ExclusiveOrExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::ExclusiveOrExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::ExclusiveOrExpr_c
| e::AndExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::ExclusiveOrExpr_c '^' r::AndExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:bitOp(ast:xorBitOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal AndExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::AndExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::AndExpr_c
| e::EqualityExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::AndExpr_c '&' r::EqualityExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:bitOp(ast:andBitOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal EqualityExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::EqualityExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::EqualityExpr_c
| e::RelationalExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::EqualityExpr_c '==' r::RelationalExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:compareOp(ast:equalsOp(location=$2.location), location=$2.location), r.ast, location=top.location); }
| l::EqualityExpr_c '!=' r::RelationalExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:compareOp(ast:notEqualsOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal RelationalExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::RelationalExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::RelationalExpr_c
| e::ShiftExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::RelationalExpr_c '<' r::ShiftExpr_c 
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:compareOp(ast:ltOp(location=$2.location), location=$2.location), r.ast, location=top.location); }
| l::RelationalExpr_c '>' r::ShiftExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:compareOp(ast:gtOp(location=$2.location), location=$2.location), r.ast, location=top.location); }
| l::RelationalExpr_c '<=' r::ShiftExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:compareOp(ast:lteOp(location=$2.location), location=$2.location), r.ast, location=top.location); }
| l::RelationalExpr_c '>=' r::ShiftExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:compareOp(ast:gteOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


closed nonterminal ShiftExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::ShiftExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::ShiftExpr_c
| e::AdditiveExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::ShiftExpr_c '<<' r::AdditiveExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:bitOp(ast:lshBitOp(location=$2.location), location=$2.location), r.ast, location=top.location); }
| l::ShiftExpr_c '>>' r::AdditiveExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:bitOp(ast:rshBitOp(location=$2.location), location=$2.location), r.ast, location=top.location); }


-- Additive Expressions --
--------------------------
closed nonterminal AdditiveExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::AdditiveExpr_c ::=
{
  top.directName = nothing();
}
{- Below is the previous implementation of AdditiveExpr_c.  
concrete productions top::AdditiveExpr_c
| e::MultiplicativeExpr_c
    { top.ast = e.ast; }
| l::AdditiveExpr_c  '+'  r::MultiplicativeExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:numOp(ast:addOp(location=$2.location), location=$2.location), r.ast, location=top.location); }
| l::AdditiveExpr_c  '-'  r::MultiplicativeExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:numOp(ast:subOp(location=$2.location), location=$2.location), r.ast, location=top.location); }           -}
concrete productions top::AdditiveExpr_c
| e::AddMulLeft_c 
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::AdditiveExpr_c  op::AdditiveOp_c  r::AddMulLeft_c 
    { top.ast = op.ast; 
      op.leftExpr=l.ast; op.rightExpr=r.ast; op.exprLocation=top.location; }

inherited attribute leftExpr :: ast:Expr;
inherited attribute rightExpr :: ast:Expr;
inherited attribute exprLocation :: Location;

closed nonterminal AdditiveOp_c 
  with location, ast<ast:Expr>, leftExpr, rightExpr, exprLocation ;

-- Additive Operators
concrete productions top::AdditiveOp_c
| '+'
    { top.ast = ovrld:addExpr(top.leftExpr, top.rightExpr, location=top.exprLocation); }
| '-'
    { top.ast = ovrld:subtractExpr(top.leftExpr, top.rightExpr, location=top.exprLocation); }

-- Operators with precedence between Additive and Multiplicitive opererators

-- Left Associative
closed nonterminal AddMulLeft_c with location, ast<ast:Expr>, directName;
aspect default production
top::AddMulLeft_c ::=
{
  top.directName = nothing();
}
concrete productions top::AddMulLeft_c
| e::AddMulRight_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::AddMulLeft_c  op::AddMulLeftOp_c r::AddMulRight_c
    { top.ast = op.ast; 
      op.leftExpr=l.ast; op.rightExpr=r.ast; op.exprLocation=top.location; }

closed nonterminal AddMulLeftOp_c
  with location, ast<ast:Expr>, leftExpr, rightExpr, exprLocation ;

terminal AddMulLeft_NEVER_t 'AddMulLeft_Never!!!nevernever1234567890' ;
concrete productions top::AddMulLeftOp_c
| AddMulLeft_NEVER_t
    { top.ast = ast:errorExpr ( [ err (top.location, "Internal Error. " ++
        "Placeholder for AddMulLeftOp_c should not appear in the tree.") ],
        location=top.location ) ; }

-- Right Associative
closed nonterminal AddMulRight_c with location, ast<ast:Expr>, directName;
aspect default production
top::AddMulRight_c ::=
{
  top.directName = nothing();
}
concrete productions top::AddMulRight_c
| e::AddMulNone_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::AddMulNone_c  op::AddMulRightOp_c r::AddMulRight_c 
    { top.ast = op.ast; 
      op.leftExpr=l.ast; op.rightExpr=r.ast; op.exprLocation=top.location; }

closed nonterminal AddMulRightOp_c
  with location, ast<ast:Expr>, leftExpr, rightExpr, exprLocation ;

terminal AddMulRight_NEVER_t 'AddMulRight_Never!!!nevernever1234567890' ;
concrete productions top::AddMulRightOp_c
| AddMulRight_NEVER_t
    { top.ast = ast:errorExpr ( [ err (top.location, "Internal Error. " ++
        "Placeholder for AddMulRightOp_c should not appear in the tree." ) ],
        location=top.location ) ; }

-- Non-associative
closed nonterminal AddMulNone_c with location, ast<ast:Expr>, directName;
aspect default production
top::AddMulNone_c ::=
{
  top.directName = nothing();
}
concrete productions top::AddMulNone_c
| e::MultiplicativeExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::MultiplicativeExpr_c  op::AddMulNoneOp_c r::MultiplicativeExpr_c 
    { top.ast = op.ast; 
      op.leftExpr=l.ast; op.rightExpr=r.ast; op.exprLocation=top.location; }

closed nonterminal AddMulNoneOp_c
  with location, ast<ast:Expr>, leftExpr, rightExpr, exprLocation ;

terminal AddMulNone_NEVER_t 'AddMulNone_Never!!!nevernever1234567890' ;
concrete productions top::AddMulNoneOp_c
| AddMulNone_NEVER_t
    { top.ast = ast:errorExpr ( [ err (top.location, "Internal Error. " ++
        "Placeholder for AddMulNoneOp_c should not appear in the tree." ++
        hackUnparse(pair(pair(top.leftExpr, top.rightExpr), top.exprLocation))) ], -- TODO: flowtype hack, remove
        location=top.location ) ; }


-- Multiplicative Expressions --
--------------------------------
closed nonterminal MultiplicativeExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::MultiplicativeExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::MultiplicativeExpr_c
| e::CastExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| l::MultiplicativeExpr_c '*' r::CastExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:numOp(ast:mulOp(location=$2.location), 
        location=$2.location), r.ast, location=top.location); }
| l::MultiplicativeExpr_c '/' r::CastExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:numOp(ast:divOp(location=$2.location),
        location=$2.location), r.ast, location=top.location); }
| l::MultiplicativeExpr_c '%' r::CastExpr_c
    { top.ast = ovrld:binaryOpExpr(l.ast, ast:numOp(ast:modOp(location=$2.location),
        location=$2.location), r.ast, location=top.location); }


closed nonterminal CastExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::CastExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::CastExpr_c
| e::UnaryExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| '(' tn::TypeName_c ')' e::CastExpr_c
    { top.ast = ovrld:explicitCastExpr(tn.ast, e.ast, location=top.location); }


closed nonterminal UnaryExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::UnaryExpr_c ::=
{
  top.directName = nothing();
}
concrete productions top::UnaryExpr_c
| e::PostfixExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| '++' e::UnaryExpr_c
    { top.ast = ovrld:unaryOpExpr(ast:preIncOp(location=$1.location), e.ast, location=top.location); }
| '--' e::UnaryExpr_c
    { top.ast = ovrld:unaryOpExpr(ast:preDecOp(location=$1.location), e.ast, location=top.location); }
| op::UnaryOp_c e::CastExpr_c
    { top.ast = op.ast;
      op.expr = e.ast; }
| 'sizeof' e::UnaryExpr_c
    { top.ast = ast:unaryExprOrTypeTraitExpr(ast:sizeofOp(location=$1.location), ast:exprExpr(e.ast), location=top.location); }
 | 'sizeof' '(' ty::TypeName_c ')'
    { top.ast = ast:unaryExprOrTypeTraitExpr(ast:sizeofOp(location=$1.location), ast:typeNameExpr(ty.ast), location=top.location); }


closed nonterminal UnaryOp_c with location, ast<ast:Expr>, expr;
inherited attribute expr :: ast:Expr;

concrete productions top::UnaryOp_c
| '&'  { top.ast = ovrld:unaryOpExpr(ast:addressOfOp(location=top.location), top.expr, location=top.location); }
| '*'  { top.ast = ovrld:dereferenceExpr(top.expr, location=top.location); }
| '+'  { top.ast = ovrld:unaryOpExpr(ast:positiveOp(location=top.location), top.expr, location=top.location); }
| '-'  { top.ast = ovrld:unaryOpExpr(ast:negativeOp(location=top.location), top.expr, location=top.location); }
| '~'  { top.ast = ovrld:unaryOpExpr(ast:bitNegateOp(location=top.location), top.expr, location=top.location); }
| '!'  { top.ast = ovrld:unaryOpExpr(ast:notOp(location=top.location), top.expr, location=top.location); }

-- Needed for constructing calls correctly
synthesized attribute directName::Maybe<Identifier_t>;

closed nonterminal PostfixExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::PostfixExpr_c ::=
{
  top.directName = nothing();
}

concrete productions top::PostfixExpr_c
| e::PrimaryExpr_c
    { top.ast = e.ast;
      top.directName = e.directName; }
| e::PostfixExpr_c '[' index::Expr_c ']'
    { top.ast = ovrld:arraySubscriptExpr(e.ast, index.ast, location=top.location); }
| e::PostfixExpr_c '(' args::ArgumentExprList_c ')'
    { top.ast = 
        case e.directName of
          just(id) -> ast:directCallExpr(ast:fromId(id), ast:foldExpr(args.ast), location=top.location)
        | nothing() -> ovrld:callExpr(e.ast, ast:foldExpr(args.ast), location=top.location)
        end; }
| e::PostfixExpr_c '(' args::ArgumentExprList_c ',' ')'
    { top.ast = 
        case e.directName of
          just(id) -> ast:directCallExpr(ast:fromId(id), ast:foldExpr(args.ast), location=top.location)
        | nothing() -> ovrld:callExpr(e.ast, ast:foldExpr(args.ast), location=top.location)
        end; }
| e::PostfixExpr_c '(' ')'
    { top.ast = 
        case e.directName of
          just(id) -> ast:directCallExpr(ast:fromId(id), ast:nilExpr(), location=top.location)
        | nothing() -> ovrld:callExpr(e.ast, ast:nilExpr(), location=top.location)
        end; }
| e::PostfixExpr_c '.' id::Identifier_t
    { top.ast = ovrld :memberExpr(e.ast, false, ast:fromId(id), location=top.location); }
| e::PostfixExpr_c '->' id::Identifier_t
    { top.ast = ovrld:memberExpr(e.ast, true, ast:fromId(id), location=top.location); }
| e::PostfixExpr_c '++'
    { top.ast = ovrld:unaryOpExpr(ast:postIncOp(location=$2.location), e.ast, location=top.location); }
| e::PostfixExpr_c '--'
    { top.ast = ovrld:unaryOpExpr(ast:postDecOp(location=$2.location), e.ast, location=top.location); }
| '(' ty::TypeName_c ')' '{' il::InitializerList_c '}'
    { top.ast = ast:compoundLiteralExpr(ty.ast, ast:foldInit(il.ast), location=top.location); }
| '(' ty::TypeName_c ')' '{' il::InitializerList_c ',' '}'
    { top.ast = ast:compoundLiteralExpr(ty.ast, ast:foldInit(il.ast), location=top.location); }


closed nonterminal ArgumentExprList_c with location, ast<[ast:Expr]>, directName;
aspect default production
top::ArgumentExprList_c ::=
{
  top.directName = nothing();
}

concrete productions top::ArgumentExprList_c
| e::AssignExpr_c
    { top.ast = [e.ast];
      top.directName = e.directName; }
| h::ArgumentExprList_c ',' t::AssignExpr_c
    { top.ast = h.ast ++ [t.ast];
      top.directName = h.directName;  }

closed nonterminal PrimaryExpr_c with location, ast<ast:Expr>, directName;
aspect default production
top::PrimaryExpr_c ::=
{
  top.directName = nothing();
}

concrete productions top::PrimaryExpr_c
| id::Identifier_t
    { top.ast = ast:declRefExpr(ast:fromId(id), location=top.location);
      top.directName = just(id); }
| c::Constant_c
    { top.ast = c.ast; }
| sl::StringConstant_c
    { top.ast = ast:stringLiteral(sl.ast, location=top.location); }
| '(' e::Expr_c  ')'
    { top.ast = ast:parenExpr(e.ast, location=top.location); }


closed nonterminal InitializerList_c with location, ast<[ast:Init]>;
concrete productions top::InitializerList_c
| i::Initializer_c 
    { top.ast = [ast:init(i.ast)]; }
| d::Designation_c  i::Initializer_c 
    { top.ast = [ast:designatedInit(d.ast, i.ast)]; }
| il::InitializerList_c ',' i::Initializer_c
    { top.ast = il.ast ++ [ast:init(i.ast)]; }
| il::InitializerList_c ',' d::Designation_c  i::Initializer_c
    { top.ast = il.ast ++ [ast:designatedInit(d.ast, i.ast)]; }


closed nonterminal Designation_c with location, ast<ast:Designator>;
concrete productions top::Designation_c
| d::DesignatorList_c '='
    { top.ast = d.ast;
      d.givenDesignator = ast:initialDesignator(); }


closed nonterminal DesignatorList_c with location, ast<ast:Designator>, givenDesignator;
concrete productions top::DesignatorList_c
| h::DesignatorList_c  t::Designator_c
    { top.ast = t.ast;
      t.givenDesignator = h.ast; }
| d::Designator_c
    { top.ast = d.ast; }

-- The previous designator to operate upon.
autocopy attribute givenDesignator :: ast:Designator;

closed nonterminal Designator_c with location, ast<ast:Designator>, givenDesignator;
concrete productions top::Designator_c
| d::ArrayDesignator_c
    { top.ast = d.ast; }
| '.' id::Identifier_t
    { top.ast = ast:fieldDesignator(top.givenDesignator, ast:fromId(id)); }


-- This Nt not strictly part of C99. Exists for ease of extensions.
closed nonterminal ArrayDesignator_c with location, ast<ast:Designator>, givenDesignator;
concrete productions top::ArrayDesignator_c
| '[' e::ConstantExpr_c ']'
    { top.ast = ast:arrayDesignator(top.givenDesignator, e.ast); }


closed nonterminal StringConstant_c with location, ast<String>; -- TODO: THIS should expand to ast nodes!
concrete productions top::StringConstant_c
| sl::StringLiteral_c
    { top.ast = sl.ast; }
| h::StringLiteral_c  t::StringConstant_c
    { top.ast = h.ast ++ " " ++ t.ast; }


closed nonterminal StringLiteral_c with location, ast<String>;
concrete productions top::StringLiteral_c
| s::StringConstant_t       -- ""
    { top.ast = s.lexeme; }
| s::StringConstantU8_t     -- u8""
    { top.ast = s.lexeme; }
| s::StringConstantL_t      -- L""
    { top.ast = s.lexeme; }
| s::StringConstantU_t      -- u""
    { top.ast = s.lexeme; }
| s::StringConstantUBig_t   -- U""
    { top.ast = s.lexeme; }
    

closed nonterminal Constant_c with location, ast<ast:Expr>;
concrete productions top::Constant_c
-- dec
| c::DecConstant_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, false, ast:noIntSuffix(), location=top.location), location=top.location); }
| c::DecConstantU_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, true, ast:noIntSuffix(), location=top.location), location=top.location); }
| c::DecConstantL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, false, ast:longIntSuffix(), location=top.location), location=top.location); }
| c::DecConstantUL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, true, ast:longIntSuffix(), location=top.location), location=top.location); }
| c::DecConstantLL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, false, ast:longLongIntSuffix(), location=top.location), location=top.location); }
| c::DecConstantULL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, true, ast:longLongIntSuffix(), location=top.location), location=top.location); }
-- oct
| c::OctConstant_t
    { top.ast = ast:realConstant(ast:octIntegerConstant(c.lexeme, false, ast:noIntSuffix(), location=top.location), location=top.location); }
| c::OctConstantU_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, true, ast:noIntSuffix(), location=top.location), location=top.location); }
| c::OctConstantL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, false, ast:longIntSuffix(), location=top.location), location=top.location); }
| c::OctConstantUL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, true, ast:longIntSuffix(), location=top.location), location=top.location); }
| c::OctConstantLL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, false, ast:longLongIntSuffix(), location=top.location), location=top.location); }
| c::OctConstantULL_t
    { top.ast = ast:realConstant(ast:integerConstant(c.lexeme, true, ast:longLongIntSuffix(), location=top.location), location=top.location); }
| c::OctConstantError_t
    { top.ast = ast:errorExpr([err(top.location, "Erroneous octal constant: " ++ c.lexeme)], location=top.location); }
-- hex
| c::HexConstant_t
    { top.ast = ast:realConstant(ast:hexIntegerConstant(c.lexeme, false, ast:noIntSuffix(), location=top.location), location=top.location); }
| c::HexConstantU_t
    { top.ast = ast:realConstant(ast:hexIntegerConstant(c.lexeme, true, ast:noIntSuffix(), location=top.location), location=top.location); }
| c::HexConstantL_t
    { top.ast = ast:realConstant(ast:hexIntegerConstant(c.lexeme, false, ast:longIntSuffix(), location=top.location), location=top.location); }
| c::HexConstantUL_t
    { top.ast = ast:realConstant(ast:hexIntegerConstant(c.lexeme, true, ast:longIntSuffix(), location=top.location), location=top.location); }
| c::HexConstantLL_t
    { top.ast = ast:realConstant(ast:hexIntegerConstant(c.lexeme, false, ast:longLongIntSuffix(), location=top.location), location=top.location); }
| c::HexConstantULL_t
    { top.ast = ast:realConstant(ast:hexIntegerConstant(c.lexeme, true, ast:longLongIntSuffix(), location=top.location), location=top.location); }
-- floats
| c::FloatConstant_t
    { top.ast = ast:realConstant(ast:floatConstant(c.lexeme, ast:doubleFloatSuffix(), location=top.location), location=top.location); }
| c::FloatConstantFloat_t
    { top.ast = ast:realConstant(ast:floatConstant(c.lexeme, ast:floatFloatSuffix(), location=top.location), location=top.location); }
| c::FloatConstantLongDouble_t
    { top.ast = ast:realConstant(ast:floatConstant(c.lexeme, ast:longDoubleFloatSuffix(), location=top.location), location=top.location); }
-- hex floats
| c::HexFloatConstant_t
    { top.ast = ast:realConstant(ast:hexFloatConstant(c.lexeme, ast:doubleFloatSuffix(), location=top.location), location=top.location); }
| c::HexFloatConstantFloat_t
    { top.ast = ast:realConstant(ast:hexFloatConstant(c.lexeme, ast:floatFloatSuffix(), location=top.location), location=top.location); }
| c::HexFloatConstantLongDouble_t
    { top.ast = ast:realConstant(ast:hexFloatConstant(c.lexeme, ast:longDoubleFloatSuffix(), location=top.location), location=top.location); }
-- characters
| c::CharConstant_t
    { top.ast = ast:characterConstant(c.lexeme, ast:noCharPrefix(), location=top.location); }
| c::CharConstantL_t
    { top.ast = ast:characterConstant(c.lexeme, ast:wcharCharPrefix(), location=top.location); }
| c::CharConstantU_t
    { top.ast = ast:characterConstant(c.lexeme, ast:char16CharPrefix(), location=top.location); }
| c::CharConstantUBig_t
    { top.ast = ast:characterConstant(c.lexeme, ast:char32CharPrefix(), location=top.location); }

