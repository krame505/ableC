/* Simple expresssion evaluation 
   using algebraic datatype as in
   ML or Haskell. */

#include <stdio.h>
#include <stdlib.h>
#include <gc.h>

typedef  datatype Expr  Expr;

datatype Expr {
  Add (Expr*, Expr*);
  Sub (Expr*, Expr*);
  Mul (Expr*, Expr*);
  Div (Expr*, Expr*);
  Const (int);
};

int value (Expr *e) {
  match (e) {
    Add(e1,e2): {return value(e1) + value(e2);}
    Sub(e1,e2): {return value(e1) - value(e2);}
    Mul(e1,e2): {return value(e1) * value(e2);}
    Div(e1,e2): {return value(e1) / value(e2);}
    Const(v): {return v;}
  }
}

int valueExpr (Expr *e) {
  return
    match (e) (
      Add(e1,e2) -> valueExpr(e1) + valueExpr(e2);
      Sub(e1,e2) -> valueExpr(e1) - valueExpr(e2);
      Mul(e1,e2) -> valueExpr(e1) * valueExpr(e2);
      Div(e1,e2) -> valueExpr(e1) / valueExpr(e2);
      Const(v) -> v;
    ) ;
}

int valueIncorrect (Expr *e) {
  return
    match (e) (
      Add(e1,e2) -> valueIncorrect(e1) + valueIncorrect(e2);
      Sub(e1,e2) -> valueIncorrect(e1) - valueIncorrect(e2);
      Mul(e1,e2) -> valueIncorrect(e1) * valueIncorrect(e2);
      Div(e1,e2) -> valueIncorrect(e1) / valueIncorrect(e2);
      _ -> 99;
    ) ;
}

int valueInexhaustive (Expr *e) {
  return
    match (e) (
      Add(e1,e2) -> valueInexhaustive(e1) + valueInexhaustive(e2);
      Sub(e1,e2) -> valueInexhaustive(e1) - valueInexhaustive(e2);
      Mul(e1,e2) -> valueInexhaustive(e1) * valueInexhaustive(e2);
      Div(e1,e2) -> valueInexhaustive(e1) / valueInexhaustive(e2);
      // Const(v) -> v;
    ) ;
}

int main () {
  Expr *t = Add( Const(3), 
                 Mul(Const(2), Const(4)) ) ;
 
  printf("value is %d\n", value(t) );

  printf("value is %d\n", valueExpr(t) );

  printf("value is %d\n", valueIncorrect(t) );

  printf("value is %d\n", valueInexhaustive(t) );
  
  return 0;   
}
