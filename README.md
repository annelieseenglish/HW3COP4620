# HW3COP4620
How to compile:
1: Generate parser (creates y.tab.c and y.tab.h)
bison -d yacc.y
2: Generate lexer (creates lex.yy.c)
flex lex.l
3: Compile everything together
gcc -o compiler y.tab.c lex.yy.c ast.c comp.c -lfl

-running with a test file do -> ./compiler < undefined_1.txt

-testfile1.txt and testfile2.txt are correct test cases
- duplicate_3.txt
 duplicatefunc_5.txt
 undeclared_4.txt
 undefined_1.txt
 variableshadows_6.txt
 wrongarity_2.txt are incorrect test cases, their number corresponds with the error described in the intructions and it should
tell you about the error.

