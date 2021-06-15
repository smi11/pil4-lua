---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 9. Closures
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 9. Closures

* Functions in Lua are first-class values with proper lexical scoping.
* A program can store functions in variables (both global and local) and in tables, pass functions as arguments to other functions, and return functions as results.
* Functions can access variables of their enclosing functions. (It also means that Lua properly contains the lambda calculus.)

## Functions as First-Class Values

```
function foo (x) return 2*x end   ==>  foo = function (x) return 2*x end
```

* A function definition is in fact a statement that creates a value of type "function" and assigns it to a variable.
* Note that, in Lua, all functions are anonymous.
* A function that takes another function as an argument, such as sort, is what we call a higher-order function.
* Higher-order functions are a powerful programming mechanism, and the use of anonymous functions to create their function arguments is a great source of flexibility.

## Non-Global Functions

* An obvious consequence of first-class functions is that we can store functions not only in global variables, but also in table fields and in local variables.
* When we store a function into a local variable, we get a local function, that is, a function that is restricted to a given scope.
* Such definitions are particularly useful for packages: because Lua handles each chunk as a function, a chunk can declare local functions, which are visible only inside the chunk.
* Lexical scoping ensures that other functions in the chunk can use these local functions.

```
local function foo (params) body  ==>  local foo; foo = function (params) body end
```

* Of course, this trick does not work if we have indirect recursive functions. In such cases, we must use the equivalent of an explicit forward declaration:

```
local f -- "forward" declaration
local function g ()
  some code f() some code
end

function f ()
  some code g() some code
end 
```

* Beware not to write local in the last definition. Otherwise, Lua would create a fresh local variable f, leaving the original f (the one that g is bound to) undefined.

## Lexical Scoping

* When we write a function enclosed in another function, it has full access to local variables from the enclosing function; we call this feature lexical scoping.

```
function sortbygrade (names, grades)
  table.sort(names, function (n1, n2)
    return grades[n1] > grades[n2] -- compare the grades
  end)
end
```

* The interesting point in this last example is that the anonymous function given to sort accesses grades, which is a parameter to the enclosing function sortbygrade.
* Inside this anonymous function, grades is neither a global variable nor a local variable, but what we call a non-local variable. (For historical reasons, non-local variables are also called upvalues in Lua.)
* Functions, being first-class values, can escape the original scope of their variables.

```
function newCounter ()
  local count = 0
  return function () -- anonymous function
    count = count + 1
    return count
  end
end

c1 = newCounter()
print(c1()) --> 1
print(c1()) --> 2
```

* In this code, the anonymous function refers to a non-local variable (count) to keep its counter.
* A closure is a function plus all it needs to access non-local variables correctly. 
* Closures are useful as arguments to higher-order functions such as sort.
* Closures are valuable for functions that build other functions too.
* Closures are useful for callback functions, too.
* Closures are valuable also in a quite different context. Because functions are stored in regular variables, we can easily redefine functions in Lua, even predefined functions.

```
do
  local oldSin = math.sin
  local k = math.pi / 180
  math.sin = function (x) return oldSin(x * k) end
end
```

* We can use this same technique to create secure environments, also called sandboxes.

## A Taste of Functional Programming

* see: functional.lua
