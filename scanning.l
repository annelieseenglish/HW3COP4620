Hw 1: Scanning

%{
#include<stdio.h>
#include<stdlib.h>

int lineNum = 1;	/* keeping track of what line were on */

void printToken(const char* token, const char* lexeme) {	/* prints tokens in lexeme format */
	printf("%s: %s\n", token, lexeme);
}
%}

digit	[0-9]	/* shortcut to define token patterns */
letter	[a-zA-Z]
whitespace	[ \t]

%%

\n	{ lineNum++; }	/*increment line counter*/
{whitespace}+	{ /* skip whitespaces and tabs */ }

"define-fun"	{printToken("function definition keyword", yytext);}
"get-int"	{printToken("predefined function", yytext);}
"if"		{printToken("conditional operator", yytext);}
"print"		{printToken("program entry point", yytext);}

{digit}+	{printToken("integer constant", yytext);}

"<="		{printToken("arithmetic comparison", yytext);}
">="		{printToken("arithmetic comparison", yytext);}
"<"		{printToken("arithmetic comparison", yytext);}
">"		{printToken("arithmetic comparison", yytext);}
"="		{printToken("arithmetic comparison", yytext);}

"+"		{printToken("arithmetic operation", yytext);}
"-"		{printToken("arithmetic operation", yytext);}
"*"		{printToken("arithmetic operation", yytext);}

"("		{printToken("left parenthesis", yytext);}
")"		{printToken("right parenthesis", yytext);}

({letter}({letter}|{digit})*)|({digit}+{letter}({letter}|{digit})*) {
	printToken("variable/function", yytext);	
}


.                           {
    fprintf(stderr, "Error: Unrecognized character '%s' at line %d\n", yytext, lineNum); /*error handling*/
    exit(1);
}

%%

int main(int argc, char** argv) {	/*check arg, open file, error check, input, scan, clean*/
    FILE* input_file;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }

    yyin = input_file;
    yylex();

    fclose(input_file);
    return 0;
}

int yywrap() {	/* called when lex reaches the end of input */
    return 1;
}



