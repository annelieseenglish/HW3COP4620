#!/bin/bash
# Script to create test case files for the parser

echo "Creating test files..."

# Test 1: Valid program with function definition
cat > test_valid.txt << 'EOF'
(define-fun factorial (n)
  (if (= n 0)
    1
    (* n (factorial (- n 1)))))

(print (factorial 5))
EOF
echo "✓ Created: test_valid.txt"

# Test 2: Valid program with conditionals and get-int
cat > test_conditionals.txt << 'EOF'
(define-fun max (a b)
  (if (> a b)
    a
    b))

(define-fun min (a b)
  (if (< a b)
    a
    b))

(print (max 10 20))
(print (min 10 20))
(print (get-int))
EOF
echo "✓ Created: test_conditionals.txt"

# Test 3: Syntax error - missing closing parenthesis
cat > test_syntax_error.txt << 'EOF'
(define-fun add (x y)
  (+ x y)

(print (add 5 10))
EOF
echo "✓ Created: test_syntax_error.txt"

# Test 4: Lexical error - invalid character
cat > test_lexical_error.txt << 'EOF'
(define-fun test (x)
  (+ x @ 5))

(print (test 10))
EOF
echo "✓ Created: test_lexical_error.txt"

# Test 5: Syntax error - wrong structure (if with wrong number of args)
cat > test_wrong_structure.txt << 'EOF'
(define-fun bad (x)
  (if (> x 0)
    (print x)))

(bad 5)
EOF
echo "✓ Created: test_wrong_structure.txt"

# Test 6: Valid nested expressions
cat > test_nested.txt << 'EOF'
(define-fun compute (a b c)
  (+ (* a b) (- c 10)))

(print (compute 3 4 20))

(define-fun compare (x y)
  (if (>= x y)
    (if (<= x 100)
      1
      0)
    (- 0 1)))

(print (compare 50 30))
EOF
echo "✓ Created: test_nested.txt"

# Test 7: Valid program with all operators
cat > test_operators.txt << 'EOF'
(print (+ 10 20))
(print (- 30 15))
(print (* 5 6))
(print (< 10 20))
(print (> 10 20))
(print (<= 10 10))
(print (>= 10 10))
(print (= 5 5))
EOF
echo "✓ Created: test_operators.txt"

# Test 8: Multiple functions
cat > test_multiple_functions.txt << 'EOF'
(define-fun double (x)
  (* x 2))

(define-fun triple (x)
  (* x 3))

(define-fun sum (a b)
  (+ a b))

(print (sum (double 5) (triple 3)))
EOF
echo "✓ Created: test_multiple_functions.txt"

# Test 9: Simple expressions
cat > test_simple.txt << 'EOF'
(print 42)
(print (+ 1 2))
(print (get-int))
EOF
echo "✓ Created: test_simple.txt"

# Test 10: Arithmetic with nested operations
cat > test_arithmetic.txt << 'EOF'
(print (+ (* 2 3) (- 10 5)))
(print (* (+ 1 2) (+ 3 4)))
(print (- (+ 10 20) (* 2 5)))
EOF
echo "✓ Created: test_arithmetic.txt"

echo ""
echo "=========================================="
echo "All test files created successfully!"
echo "=========================================="
echo ""
echo "Test files created:"
echo "  ✓ test_valid.txt - Valid function definition"
echo "  ✓ test_conditionals.txt - Valid conditionals"
echo "  ✓ test_syntax_error.txt - Missing closing parenthesis"
echo "  ✓ test_lexical_error.txt - Invalid character (@)"
echo "  ✓ test_wrong_structure.txt - Wrong if structure"
echo "  ✓ test_nested.txt - Nested expressions"
echo "  ✓ test_operators.txt - All operators"
echo "  ✓ test_multiple_functions.txt - Multiple functions"
echo "  ✓ test_simple.txt - Simple expressions"
echo "  ✓ test_arithmetic.txt - Arithmetic operations"
echo ""
echo "Run tests with:"
echo "  ./parser test_valid.txt"
echo "  make test"
