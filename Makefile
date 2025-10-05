CC = gcc
CFLAGS = -Wall -g
YACC = yacc
LEX = lex

# Default target - build the parser
all: parser

# Generate parser from yacc file
y.tab.c y.tab.h: parser.y
	$(YACC) -d parser.y

# Generate scanner from lex file
lex.yy.c: scanner.l y.tab.h
	$(LEX) scanner.l

# Compile parser
parser: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o parser y.tab.c lex.yy.c -ll

# Clean build artifacts
clean:
	rm -f parser lex.yy.c y.tab.c y.tab.h *.o

# Run all test cases
test: parser
	@echo "======================================"
	@echo "Test 1: Valid program with functions"
	@echo "======================================"
	-./parser test_valid.txt
	@echo ""
	@echo "======================================"
	@echo "Test 2: Valid conditionals"
	@echo "======================================"
	-./parser test_conditionals.txt
	@echo ""
	@echo "======================================"
	@echo "Test 3: Syntax error - missing paren"
	@echo "======================================"
	-./parser test_syntax_error.txt
	@echo ""
	@echo "======================================"
	@echo "Test 4: Lexical error - invalid char"
	@echo "======================================"
	-./parser test_lexical_error.txt
	@echo ""
	@echo "======================================"
	@echo "Test 5: Wrong structure"
	@echo "======================================"
	-./parser test_wrong_structure.txt

# Run individual test
run: parser
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make run FILE=test_valid.txt"; \
	else \
		./parser $(FILE); \
	fi

.PHONY: all clean test run
