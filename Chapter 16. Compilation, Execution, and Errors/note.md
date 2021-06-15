---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 16. Compilation, Execution, and Errors
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 16. Compilation, Execution, and Errors

* In this chapter, we will discuss in more details the process that Lua uses for running its chunks, what compilation means (and does), how Lua runs that compiled code, and how it handles errors in that process.

## Compilation

```
function dofile (filename)
  local f = assert(loadfile(filename))
  return f()
end
```

* For simple tasks, `dofile` is handy, because it does the complete job in one call.
* `loadfile` is more flexible. In case of error, `loadfile` returns nil plus the error message, which allows us to handle the error in customized ways.
* The function `load` is similar to `loadfile`, except that it reads its chunk from a string or from a function, not from a file.
* quick-and-dirty dostring: `assert(load(s))()`
* `load` always compiles its chunks in the global environment.
* We can call `load` also with a _reader function_ as its first argument: `f = load(io.lines(filename, "*L"))`
* Lua treats any independent chunk as the body of an anonymous variadic function. For instance, `load("a = 1")` returns the equivalent of the following expression: `function (...) a = 1 end`

## Precompiled Code

* Lua precompiles source code before running it.
* Lua also allows us to distribute code in precompiled form.

```
$ luac -o prog.lc prog.lua
$ lua prog.lc
```

* Both `loadfile` and `load` accept precompiled code.
* The option `-l` of `luac` lists the opcodes that the compiler generates for a given chunk.

## Errors

* Any unexpected condition that Lua encounters raises an error.
* We can also explicitly raise an error calling the function `error`, with an error message as an argument.
* The function `assert` checks whether its first argument is not false and simply returns this argument; if the argument is false, `assert` raises an error.

```
file = assert(io.open(name, "r"))
  --> stdin:1: no-file: No such file or directory
```

* This is a typical Lua idiom: if `io.open` fails, `assert` will raise an error. Notice how the error message, which is the second result from `io.open`, goes as the second argument to `assert`.

## Error Handling and Exceptions

* For many applications, we do not need to do any error handling in Lua; the application program does this handling.
* However, if we want to handle errors inside the Lua code, we should use the function `pcall` (protected call) to encapsulate our code.

```
local ok, msg = pcall(function ()
  some code
  if unexpected_condition then
    error()
  end
  some code
  print(a[i])         -- potential error: 'a' may not be a table
  some code
end)

if ok then            -- no errors while running protected code
  regular code
else                  -- protected code raised an error: take appropriate action
  error-handling code
end
```

* The function `pcall` calls its first argument in protected mode, so that it catches any errors while the function is running.
* The function `pcall` never raises any error, no matter what.
* If there are no errors, `pcall` returns true, plus any values returned by the call. Otherwise, it returns false, plus the error message.
* `pcall` will return any Lua value that we pass to error:

```
local status, err = pcall(function () error({code=121}) end)
print(err.code) --> 121
```

## Error Messages and Tracebacks

* Although we can use a value of any type as an error object, usually error objects are strings describing what went wrong.
* Whenever the error object is a string, Lua tries to add some information about the location where the error happened:

```
local status, err = pcall(function () error("my error") end)
print(err) --> stdin:1: my error
```

* The location information gives the chunk's name (stdin, in the example) plus the line number (1, in the example).
* The function `error` has an additional second parameter, which gives the level where it should report the error.
* Level 1 is our own function, level 2 is the calling function, etc...
* If we want a traceback, we must build it before `pcall` returns.
* `xpcall` works like `pcall`, but its second argument is a message handler function.
* Lua calls this message handler before the stack unwinds, so that it can use the debug library to gather any extra information it wants about the error.
* Two common message handlers are `debug.debug`, which gives us a Lua prompt so that we can inspect by ourselves what was going on when the error happened; and `debug.traceback`, which builds an extended error message with a traceback.
