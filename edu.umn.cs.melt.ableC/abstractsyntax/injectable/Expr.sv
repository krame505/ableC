grammar edu:umn:cs:melt:ableC:abstractsyntax:injectable;

imports edu:umn:cs:melt:ableC:abstractsyntax
                                             with unaryOpExpr as unaryOpExprDefault,
                                                  arraySubscriptExpr as arraySubscriptExprDefault,
                                                  callExpr as callExprDefault,
                                                  memberExpr as memberExprDefault,
                                                  dereferenceExpr as dereferenceExprDefault,
                                                  explicitCastExpr as explicitCastExprDefault,
                                                  addExpr as addExprDefault,
                                                  subtractExpr as subtractExprDefault,
                                                  binaryOpExpr as binaryOpExprDefault;

abstract production dereferenceExpr
top::Expr ::= e::Expr
{
  top.pp = parens( cat(text("*"), e.pp) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[RuntimeMod] with ++;
  runtimeMods := [];

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        dereferenceExprDefault(applyMods(runtimeMods, e), location=top.location),
        top.location),
      top.location);
}

abstract production unaryOpExpr
top::Expr ::= op::UnaryOp  e::Expr
{
  top.pp = if op.preExpr
           then parens( cat( op.pp, e.pp ) )
           else parens( cat( e.pp, op.pp ) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];
  op.op = e;

  production attribute runtimeMods::[RuntimeMod] with ++;
  runtimeMods := [];

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        unaryOpExprDefault(op, applyMods(runtimeMods, e), location=top.location),
        top.location),
      top.location);
}

abstract production arraySubscriptExpr
top::Expr ::= lhs::Expr  rhs::Expr
{
  top.pp = parens( ppConcat([ lhs.pp, brackets( rhs.pp )]) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[LhsOrRhsRuntimeMod] with ++;
  runtimeMods := [];
  local modLhsRhs :: Pair<Expr Expr> = applyLhsRhsMods(runtimeMods, lhs, rhs);

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        arraySubscriptExprDefault(modLhsRhs.fst, modLhsRhs.snd, location=top.location),
        top.location),
      top.location);
}

abstract production memberExpr
top::Expr ::= lhs::Expr  deref::Boolean  rhs::Name
{
  top.pp = parens(ppConcat([lhs.pp, text(if deref then "->" else "."), rhs.pp]));
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[RuntimeMod] with ++;
  runtimeMods := [];

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        memberExprDefault(applyMods(runtimeMods, lhs), deref, rhs, location=top.location),
        top.location),
      top.location);
}

abstract production addExpr
top::Expr ::= lhs::Expr rhs::Expr
{
  top.pp = parens( ppConcat([lhs.pp, space(), text("+"), space(), rhs.pp]) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[LhsOrRhsRuntimeMod] with ++;
  runtimeMods := [];
  local modLhsRhs :: Pair<Expr Expr> = applyLhsRhsMods(runtimeMods, lhs, rhs);

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        addExprDefault(modLhsRhs.fst, modLhsRhs.snd, location=top.location),
        top.location),
      top.location);
}

abstract production subtractExpr
top::Expr ::= lhs::Expr rhs::Expr
{
  top.pp = parens( ppConcat([lhs.pp, space(), text("+"), space(), rhs.pp]) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[LhsOrRhsRuntimeMod] with ++;
  runtimeMods := [];
  local modLhsRhs :: Pair<Expr Expr> = applyLhsRhsMods(runtimeMods, lhs, rhs);

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        subtractExprDefault(modLhsRhs.fst, modLhsRhs.snd, location=top.location),
        top.location),
      top.location);
}

abstract production binaryOpExpr
top::Expr ::= lhs::Expr  op::BinOp  rhs::Expr
{
  top.pp = parens( ppConcat([ 
    {-case op, lhs.pp of
    | assignOp(eqOp()), cat(cat(text("("), lhsNoParens), text(")")) -> lhsNoParens
    | _, _ -> lhs.pp
    end-} lhs.pp, space(), op.pp, space(), rhs.pp ]) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[LhsOrRhsRuntimeMod] with ++;
  runtimeMods := op.lhsRhsRuntimeMods;
  local modLhsRhs :: Pair<Expr Expr> = applyLhsRhsMods(runtimeMods, lhs, rhs);

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  op.lop = lhs;
  op.rop = rhs;
  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        binaryOpExprDefault(lhs, op, rhs, location=top.location),
        top.location),
      top.location);
}

abstract production explicitCastExpr
top::Expr ::= ty::TypeName  e::Expr
{
  top.pp = parens( ppConcat([parens(ty.pp), e.pp]) );
  production attribute lerrors :: [Message] with ++;
  lerrors := [];

  production attribute runtimeMods::[RuntimeMod] with ++;
  runtimeMods := [];

  production attribute collectedTypeQualifiers :: [Qualifier] with ++;
  collectedTypeQualifiers := [];

  forwards to
    wrapWarnExpr(lerrors,
      wrapQualifiedExpr(collectedTypeQualifiers,
        explicitCastExprDefault(ty, applyMods(runtimeMods, e), location=top.location),
        top.location),
      top.location);
}
