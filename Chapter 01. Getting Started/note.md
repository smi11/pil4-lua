---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 1. Getting Started
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 1. Getting Started

    print("Hello World")

## Chunks

* We call each piece of code that Lua executes, such as a file or a single line in interactive mode, a chunk. A chunk is simply a sequence of commands (or statements).
* Instead of writing your program to a file, you can run the stand-alone interpreter in interactive mode.
* Starting in version 5.3, we can enter expressions directly in the interactive mode, and Lua will print their values. In older versions, we need to precede these expressions with an equals sign.
* Another way to run chunks is with the function `dofile`, which immediately executes a file.

## Some Lexical Conventions

* Identifiers (or names) in Lua can be any string of letters, digits, and underscores, not beginning with a digit.
* Lua is case-sensitive: `and` is a reserved word, but `And` and `AND` are two different identifiers.
* A comment starts anywhere with two consecutive hyphens `--` and runs until the end of the line. Lua also offers long comments, which start with two hyphens followed by two opening square brackets and un until the first occurrence of two consecutive closing square brackets.

```
-- single line comment

--[[
multiline
comment
--]]
```

* Lua needs no separator between consecutive statements, but we can use a semicolon if we wish.

## Global Variables

* Global variables do not need declarations; we simply use them. It is not an error to access a non-initialized variable; we just get the value nil as the result.

## Types and Values

* Lua is a dynamically-typed language. There are no type definitions in the language; each value carries its own type.

```
> type(nil)           --> nil
> type(true)          --> boolean
> type(10.4 * 3)      --> number
> type("Hello world") --> string
> type(io.stdin)      --> userdata
> type(print)         --> function
> type(type)          --> function
> type({})            --> table
> type(type(X))       --> string
```

## Nil

* Nil is a type with a single value, nil, whose main property is to be different from any other value. Lua uses nil as a kind of non-value, to represent the absence of a useful value.
* A global variable has a nil value by default, before its first assignment, and we can assign nil to a global variable to delete it.

## Booleans

* The Boolean type has two values, _@false{}_ and _@true{}_, which represent the traditional Boolean values.
* Conditional tests (e.g., conditions in control structures) consider both the Boolean false and nil as false and anything else as true.
* In particular, Lua considers both zero and the empty string as true in conditional tests.

```
> 4 and 5           --> 5
> nil and 13        --> nil
> false and 13      --> false
> 0 or 5            --> 0
> false or "hi"     --> "hi"
> nil or false      --> false
```

* Both `and` and `or` use short-circuit evaluation, that is, they evaluate their second operand only when necessary.
* Short-circuit evaluation ensures that expressions like `i ~= 0 and a/i > b` do not cause run-time errors. Lua will not try to evaluate `a / i` when `i` is zero.

```
x = x or v   <==>   if not x then x = v end
```

```
a and b or c   <==>   if a then b else c end  -- on condition that b is not false
```

* The not operator always gives a Boolean value.

```
> not nil       --> true
> not false     --> true
> not 0         --> false
> not not 1     --> true
> not not nil   --> false
```

## The Stand-Alone Interpreter

* The stand-alone interpreter (also called lua.c due to its source file or simply lua due to its executable) is a small program that allows the direct use of Lua.
* When the interpreter loads a file, it ignores its first line if this line starts with a hash (#). For example: `#!/usr/local/bin/lua`
* This feature allows the use of Lua as a script interpreter in POSIX systems.
* The -e option allows us to enter code directly into the command line:

```
% lua -e "print(math.sin(12))" --> -0.53657291800043
```

* The `-l` option loads a library. `-i` enters interactive mode after running the other arguments. Therefore, the next call will load the lib library, then execute the assignment x = 10, and finally present a prompt for interaction.

```
% lua -i -llib -e "x = 10"
```

* Before running its arguments, the interpreter looks for an environment variable named `LUA_INIT_5_3` or else, if there is no such variable, `LUA_INIT`. If there is one of these variables and its content is _@file-name_, then the interpreter runs the given file. If `LUA_INIT_5_3` (or `LUA_INIT`) is defined but it does not start with an at-sign, then the interpreter assumes that it contains Lua code and runs it.
* `LUA_INIT` gives us great power when configuring the stand-alone interpreter, because we have the full power of Lua in the configuration. We can preload packages, change the path, define our own functions, rename or delete functions, and so on.
* A script can retrieve its arguments through the predefined global variable `arg`.

```
% lua -e "sin=math.sin" script a b

arg[-3] = "lua"
arg[-2] = "-e"
arg[-1] = "sin=math.sin"
arg[0] = "script"
arg[1] = "a"
arg[2] = "b"
```

* A script can also retrieve its arguments through a vararg expression. In the main body of a script, the expression `...` results in the arguments to the script.
