%{
  void yyerror (char *s);
  int yylex();
  #include "ast.h"
%}
%union {int val; char* str;}
%start program
%token PLUS MINUS MULT EQ LT GT GE LE IF LPAR RPAR GETINT DEFFUN PRINT CALL FUNID INP VARID
%token<str> ID CONST
%type<val> expr term id
%%
program : LPAR PRINT term RPAR {
  int id = insert_node("main", FUNID);
  insert_children (2, id, $3);
  insert_node("ENTRY", PRINT);
}
| LPAR DEFFUN LPAR id RPAR term RPAR program {
  insert_children (2, $4, $6);
  insert_node("DEFINE", DEFFUN);
}
| LPAR DEFFUN LPAR id ID RPAR term RPAR program {
  int id2 = insert_node($5, INP);
  insert_children (3, $4, id2, $7);
  insert_node("DEFINE", DEFFUN);
}
| LPAR DEFFUN LPAR id ID ID RPAR term RPAR program {
  int id2 = insert_node($5, INP);
  int id3 = insert_node($6, INP);
  insert_children (4, $4, id2, id3, $8);
  insert_node("DEFINE", DEFFUN);
};
id: ID {$$ = insert_node($1, FUNID);};
term:  CONST { $$ = insert_node ($1, CONST);}
| ID { $$ = insert_node($1, VARID);}
| LPAR PLUS term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("PLUS", PLUS);}
| LPAR MINUS term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("MINUS", MINUS);}
| LPAR MULT term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("MULT", MULT);}
| LPAR IF expr term term RPAR {
  insert_children (3, $3, $4, $5);
  $$ = insert_node("IF", IF);}
| LPAR ID RPAR {
  $$ = insert_node($2, CALL);}
| LPAR ID term RPAR {
  insert_child ($3);
  $$ = insert_node($2, CALL);}
| LPAR ID term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node($2, CALL);}
| LPAR GETINT RPAR {
  $$ = insert_node("GET-INT", GETINT);}
expr : LPAR EQ term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("EQ", EQ);}
| LPAR LT term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("LT", LT);}
| LPAR LE term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("LE", LE);}
| LPAR GE term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("GE", GE);}
| LPAR GT term term RPAR {
  insert_children (2, $3, $4);
  $$ = insert_node("GT", GT);}
;
%%
void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
