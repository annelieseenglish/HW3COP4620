%{
  #include "y.tab.h"
  int yylex();
%}
%%

[ \t\n] {}
";".+$ ;
[-]?([1-9][0-9]*|0) { /*fprintf(stderr,"line %d: integer const: \t\t%s\n", yylineno, yytext);*/ yylval.str = strdup(yytext); return CONST;}
"=" {/*fprintf(stderr,"line %d: equality: \t\t\t%s\n", yylineno, yytext);*/ return EQ;}
"<" {/*fprintf(stderr,"line %d: comparison: \t\t%s\n", yylineno, yytext);*/ return LT;}
">" {/*fprintf(stderr,"line %d: comparison: \t\t%s\n", yylineno, yytext);*/ return GT;}
"<=" {/*fprintf(stderr,"line %d: comparison: \t\t%s\n", yylineno, yytext);*/ return LE;}
">=" {/*fprintf(stderr,"line %d: comparison: \t\t%s\n", yylineno, yytext);*/ return GE;}
"+" {/*fprintf(stderr,"line %d: plus: \t\t\t%s\n", yylineno, yytext);*/ return PLUS;}
"-" {/*fprintf(stderr,"line %d: minus: \t\t\t\t%s\n", yylineno, yytext);*/ return MINUS;}
"*" {/*fprintf(stderr,"line %d: multiply: \t\t\t%s\n", yylineno, yytext);*/ return MULT;}
"define-fun" {/*fprintf(stderr,"line %d: function definition: %s\n", yylineno, yytext);*/ return DEFFUN;}
"get-int" {/*fprintf(stderr,"line %d: function call: \t\t%s\n", yylineno, yytext);*/ return GETINT;}
"if" {/*fprintf(stderr,"line %d: if-then-else: \t\t%s\n", yylineno, yytext);*/ return IF;}
"print" {/*fprintf(stderr,"line %d: program entry: \t\t%s\n", yylineno, yytext);*/ return PRINT;}
[a-zA-Z][a-zA-Z0-9]* { yylval.str = strdup(yytext); /*fprintf(stderr,"line %d: id: \t\t\t\t%s\n", yylineno, yylval.str);*/ return ID;}
[(] {/*fprintf(stderr,"line %d: left parenthesis: \t%s\n", yylineno, yytext);*/ return LPAR;}
[)] {/*fprintf(stderr,"line %d: right parenthesis: \t%s\n", yylineno, yytext);*/ return RPAR;}
%%

int yywrap(void) {return 1;}
