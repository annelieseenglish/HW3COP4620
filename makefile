CC		= gcc
YACC	= yacc
LEX		= lex

comp:	y.tab.c lex.yy.c ast.c comp.c
	$(CC) lex.yy.c y.tab.c ast.c comp.c -o comp

y.tab.c: yacc.y
	$(YACC) -d yacc.y

lex.yy.c: lex.l y.tab.h
	$(LEX) lex.l

clean:
	rm comp lex.yy.c y.tab.c y.tab.h
