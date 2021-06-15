---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 8. Filling some Gaps
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 8. Filling some Gaps

## Local Variables and Blocks

* By default, variables in Lua are global. All local variables must be declared as such.

```
x = 10
local i = 1 -- local to the chunk

while i <= x do
  local x = i * 2 -- local to the while body
  print(x) --> 2, 4, 6, 8, ...
  i = i + 1
end

if i > 20 then
  local x -- local to the "then" body
  x = 20
  print(x + 2) -- (would print 22 if test succeeded)
else
  print(x) --> 10 (the global one)
end

print(x) --> 10 (the global one)
```

* `do` blocks are useful when we need finer control over the scope of some local variables:

```
local x1, x2
do
  local a2 = 2*a
  local d = (b^2 - 4*a*c)^(1/2)
  x1 = (-b + d)/a2
  x2 = (-b - d)/a2
end -- scope of 'a2' and 'd' ends here
print(x1, x2) -- 'x1' and 'x2' still in scope
```

* If a declaration has no initial assignment, it initializes all its variables with nil:

```
local a, b = 1, 10
if a < b then
  print(a) --> 1
  local a -- '= nil' is implicit
  print(a) --> nil
end -- ends the block started at 'then'
print(a, b) --> 1 10
```

* A common idiom in Lua is `local foo = foo` 
* This code creates a local variable, `foo`, and initializes it with the value of the global variable `foo`. (The local `foo` becomes visible only after its declaration.) This idiom is useful to speed up the access to `foo`.

## Control Structures

### `if then else`

```
if a < 0 then a = 0 end
if a < b then return a else return b end
if line > MAXLINES then
  showpage()
  line = 0
end

if op == "+" then
  r = a + b
elseif op == "-" then
  r = a - b
elseif op == "*" then
  r = a*b
elseif op == "/" then
  r = a/b
else
  error("invalid operation")
end
```

### `while`

```
local i = 1
while a[i] do
  print(a[i])
  i = i + 1
end
```

### `repeat`

```
-- print the first non-empty input line
local line
repeat
  line = io.read()
until line ~= ""
print(line)

-- computes the square root of 'x' using Newton-Raphson method
local sqr = x / 2
repeat
  sqr = (sqr + x/sqr) / 2
  local error = math.abs(sqr^2 - x)
until error < x/10000 -- local 'error' still visible here
```

### Numerical `for`

* The `for` statement has two variants: the numerical `for` and the generic `for`.

```
for var = exp1, exp2, exp3 do
  something
end
```

* This loop will execute something for each value of `var` from exp1 to exp2, using exp3 as the step to increment `var`.
* This third expression is optional; when absent, Lua assumes one as the step value.
* If we want a loop without an upper limit, we can use the constant `math.huge` for exp2.
* All three expressions are evaluated once, before the loop starts.
* The control variable `var` is a local variable automatically declared by the `for` statement, and it __is visible only inside the loop__.

### Generic `for`

* The generic `for` loop traverses all values returned by an iterator function.
* See: Chapter 18, Iterators and the Generic `for`.
* Unlike the numerical `for`, the generic `for` can have multiple variables, which are all updated at each iteration. The loop stops when the first variable gets nil.

### `break`, `return`, and `goto`

* We use the `break` statement to finish a loop. This statement breaks the inner loop (for, repeat, or while) that contains it; it cannot be used outside a loop.
* A `return` statement returns the results from a function or simply finishes the function. There is an implicit `return` at the end of any function, so we do not need to write one for functions that end naturally, without returning any value.
* For syntactic reasons, a `return` can appear only as the last statement of a block: in other words, as the last statement in our chunk or just before an `end`, an `else`, or an `until`.
* A `goto` statement jumps the execution of a program to a corresponding label.
* In Lua, the syntax for a `goto` statement is the reserved word goto followed by the label name, which can be any valid identifier.
* The syntax for a label has two colons followed by the label name followed by more two colons, like in `::name::`.
