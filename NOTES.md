This file has random notes that I write during the livestream. They generally
have a rough outline of what I hoped to accomplish at the start of a session
and some scribblings about the details. See the recording for more details.

# March 7, 2021

Goal: Add support for `if` expressions.

Example:

    + 1 2 => 3
    if 0 1 2 => 2
    if + 1 2 3 4 => 3

    * if 0 1 2 if 1 2 3 => 6

Tasks:

1. Refactor, build tests
2. Write string compare function
3. Add `if` evaluation
   * Add a way to read without evaluation


# February 28, 2021

Goal: Prefix arithmetic calculator

Tasks:

1. Read input from console (not at first)
2. Tokenize / parse (operators, operands [i.e. numbers])
3. Compute

get_token():
  returns numbers as numbers
  operators will be negative numbers
    + : -1
    * : -2

compute():
  t = get_token()
  if t == -1:
    a = compute()
    b = compute()
    return a + b
  else if t == -2:
    a = compute()
    b = compute()
    return a * b
  else:
    return t

# February 7, 2021

1. Prefix arithmetic calculator
2. Print numbers
3. Parse numbers

## Prefix Arithmetic

Infix
    1 + 2 = 3

    (1 + 2) * 3 

Prefix
    + 1 2 
    3

    * 3 + 1 2

    + 42 12
    54

Postfix
    1 2 +
    3

    1 2 + 3 *

## Print numbers

12345

5
4
3
2
1
0

number % 10
number /= 10

5
4
3
2
1

54321