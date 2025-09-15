Hw 1: Scanning

%{
#include<stdio.h>
#include<stdlib.h>

int lineNum = 1;	//keeping track of what line were on

void printToken(const char* token, const char* lexeme) {
	printf("%s\n", token, lexeme);
}
%}

digit	[0-9]	//define token patterns
letter	[a-z A-Z]
whitespace	[ \t]

%%

\n	{ lineNum++; }
{whitespace}++	{ //skip whitespaces and tabs}

"define-func"	{printToken("function def keyword", yytext);}
"get-int"	{printToken("pre-defined function", yytext);}
"if"		{printToken("conditional operator", yytext);}
"print"		{printToken("program entry point", yytext);}

{digit}+	{printToken("integer constant", yytext);}

"










