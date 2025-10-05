%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int lineNum;
extern char* yytext;
extern FILE* yyin;

void yyerror(const char* s);
%}

%token DEFINE_FUN
%token GET_INT
%token IF
%token PRINT
%token INTEGER
%token LE GE LT GT EQ
%token PLUS MINUS MULT
%token LPAREN RPAREN
%token IDENTIFIER

/* Operator precedence and associativity */
%left PLUS MINUS
%left MULT
%right UMINUS

%%

/* Grammar productions */

program:
    statement_list
    {
        printf("\n=== Parsing completed successfully! ===\n");
    }
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    function_definition
    | expression
    ;

function_definition:
    LPAREN DEFINE_FUN IDENTIFIER LPAREN parameter_list RPAREN expression RPAREN
    {
        printf("Recognized: Function definition\n");
    }
    | LPAREN DEFINE_FUN IDENTIFIER LPAREN RPAREN expression RPAREN
    {
        printf("Recognized: Function definition (no parameters)\n");
    }
    ;

parameter_list:
    IDENTIFIER
    | parameter_list IDENTIFIER
    ;

expression:
    INTEGER
    {
        printf("Recognized: Integer literal\n");
    }
    | IDENTIFIER
    {
        printf("Recognized: Variable/function reference\n");
    }
    | LPAREN GET_INT RPAREN
    {
        printf("Recognized: get-int call\n");
    }
    | LPAREN PRINT expression RPAREN
    {
        printf("Recognized: print statement\n");
    }
    | LPAREN IF expression expression expression RPAREN
    {
        printf("Recognized: if expression\n");
    }
    | LPAREN arithmetic_op expression expression RPAREN
    {
        printf("Recognized: Binary arithmetic operation\n");
    }
    | LPAREN comparison_op expression expression RPAREN
    {
        printf("Recognized: Comparison operation\n");
    }
    | LPAREN IDENTIFIER argument_list RPAREN
    {
        printf("Recognized: Function call\n");
    }
    | LPAREN IDENTIFIER RPAREN
    {
        printf("Recognized: Function call (no arguments)\n");
    }
    | LPAREN MINUS expression RPAREN %prec UMINUS
    {
        printf("Recognized: Unary minus\n");
    }
    ;

argument_list:
    expression
    | argument_list expression
    ;

arithmetic_op:
    PLUS
    | MINUS
    | MULT
    ;

comparison_op:
    LT
    | GT
    | LE
    | GE
    | EQ
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "\n*** SYNTAX ERROR at line %d ***\n", lineNum);
    fprintf(stderr, "Error: %s\n", s);
    fprintf(stderr, "Near token: '%s'\n", yytext);
}

int main(int argc, char** argv) {
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
    
    printf("=== Starting syntax analysis ===\n\n");
    int result = yyparse();
    
    fclose(input_file);
    
    if (result != 0) {
        printf("\n=== Parsing failed with errors ===\n");
        return 1;
    }
    
    return 0;
}
