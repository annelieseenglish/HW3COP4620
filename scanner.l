Hw 2: Parser

%{
#include "y.tab.h"  
#include <stdio.h>
#include <stdlib.h>

int lineNum = 1;  /* keeping track of what line we're on */

void printToken(const char* token, const char* lexeme) {
    /* Commented out for parser mode - uncomment for scanner-only debugging */
    /* printf("%s: %s\n", token, lexeme); */
}
%}

digit       [0-9]
letter      [a-zA-Z]
whitespace  [ \t]

%option noyywrap

%%

\n  { lineNum++; }  /* increment line counter */

{whitespace}+  { /* skip whitespaces and tabs */ }

"define-fun"  { 
    printToken("function definition keyword", yytext); 
    return DEFINE_FUN; 
}

"get-int"  { 
    printToken("predefined function", yytext); 
    return GET_INT; 
}

"if"  { 
    printToken("conditional operator", yytext); 
    return IF; 
}

"print"  { 
    printToken("program entry point", yytext); 
    return PRINT; 
}

[0-9]+  { 
    printToken("integer constant", yytext); 
    return INTEGER; 
}

"<="  { 
    printToken("arithmetic comparison", yytext); 
    return LE; 
}

">="  { 
    printToken("arithmetic comparison", yytext); 
    return GE; 
}

"<"  { 
    printToken("arithmetic comparison", yytext); 
    return LT; 
}

">"  { 
    printToken("arithmetic comparison", yytext); 
    return GT; 
}

"="  { 
    printToken("arithmetic comparison", yytext); 
    return EQ; 
}

"+"  { 
    printToken("arithmetic operation", yytext); 
    return PLUS; 
}

"-"  { 
    printToken("arithmetic operation", yytext); 
    return MINUS; 
}

"*"  { 
    printToken("arithmetic operation", yytext); 
    return MULT; 
}

"("  { 
    printToken("left parenthesis", yytext); 
    return LPAREN; 
}

")"  { 
    printToken("right parenthesis", yytext); 
    return RPAREN; 
}

[a-zA-Z][a-zA-Z0-9]*  { 
    printToken("variable/function", yytext); 
    return IDENTIFIER; 
}

.  {
    fprintf(stderr, "Error: Unrecognized character '%s' at line %d\n", yytext, lineNum);
    exit(1);
}

%%



