
function ppAttributes
Document ::= l::[Attribute]  env::Decorated Env
{
  return terminate(space(), map(ppAttribute(_, env), l));
}
function ppAttributesRHS
Document ::= l::[Attribute]  env::Decorated Env
{
  return initiate(space(), map(ppAttribute(_, env), l));
}


function ppAttribute
Document ::= a::Attribute env::Decorated Env
{
  a.env = env;
  a.returnType = nothing(); -- TODO: fix flow dependencies
  return a.pp;
}
function ppAttrib
Document ::= a::Attrib env::Decorated Env
{
  a.env = env;
  a.returnType = nothing(); -- TODO: fix flow dependencies
  return a.pp;
}

{-- __attribute__ syntax representation -}
nonterminal Attribute with pp, env, returnType;

abstract production gccAttribute
top::Attribute ::= l::[Attrib]
{
  top.pp = concat([text("__attribute__(("), ppImplode(text(", "), map(ppAttrib(_, top.env), l)), text("))")]);
}

abstract production simpleAsm
top::Attribute ::= s::String
{
  top.pp = text("__asm__(" ++ s ++ ")");
}


nonterminal Attrib with pp, env, returnType;

-- e.g. __attribute__(())
abstract production emptyAttrib
top::Attrib ::=
{
  top.pp = notext();
}
-- e.g. __attribute__((deprecated))
abstract production wordAttrib
top::Attrib ::= n::AttribName
{
  top.pp = n.pp;
}
-- e.g. __attribute__((deprecated("don't use this duh")))
abstract production appliedAttrib
top::Attrib ::= n::AttribName  e::Exprs
{
  top.pp = concat([n.pp, parens(ppImplode(text(", "), e.pps))]);
}
-- e.g. __attribute__((something(foo, "well whatever")))
-- OR __attribute__((something(foo)))
abstract production idAppliedAttrib
top::Attrib ::= n::AttribName  id::Name  e::Exprs
{
  top.pp = concat([n.pp, parens(ppImplode(text(", "), id.pp :: e.pps))]);
}


nonterminal AttribName with pp, env;

abstract production attribName
top::AttribName ::= n::Name
{
  top.pp = n.pp;
}

