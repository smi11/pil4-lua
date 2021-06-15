---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 25. Reflection
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# Chapter 25. Reflection

* The debug library comprises two kinds of functions: introspective functions and hooks.
* Introspective functions allow us to inspect several aspects of the running program, such as its stack of active functions, current line of execution, and values and names of local variables.
* Hooks allow us to trace the execution of a program.

## Introspective Facilities

* The main introspective function in the debug library is `getinfo`.
* Its first parameter can be a function or a stack level.
* When we call `debug.getinfo(n)` for some number n, we get data about the function active at that stack level. A stack level is a number that refers to a particular function that is active at that moment.
* The function getinfo is not efficient.
* To achieve better performance, getinfo has an optional second parameter that selects what information to get.

## Accessing local variables

* We can inspect the local variables of any active function with `debug.getlocal`.
* We can also change the values of local variables, with `debug.setlocal`.

## Accessing non-local variables

* The debug library also allows us to access the non-local variables used by a Lua function, with `getupvalue`.
* Unlike local variables, the non-local variables referred by a function exist even when the function is not active (this is what closures are about, after all).
* Therefore, the first argument for `getupvalue` is not a stack level, but a function (a closure, more precisely).
* See: Figure 25.1. Getting the value of a variable

## Accessing other coroutines

* All introspective functions from the debug library accept an optional coroutine as their first argument, so that we can inspect the coroutine from the outside.
* When a coroutine raises an error, it does not unwind its stack. This means that we can inspect it after the error.

## Hooks

* The hook mechanism of the debug library allows us to register a function to be called at specific events as a program runs.

1. call events happen every time Lua calls a function;
2. return events happen every time a function returns;
3. line events happen when Lua starts executing a new line of code;
4. count events happen after a given number of instructions. (Instructions here mean internal opcodes, which we visited briefly in the section called “Precompiled Code”.)

* To register a hook, we call `debug.sethook` with two or three arguments: the first argument is the hook function; the second argument is a mask string, which describes the events we want to monitor; and the optional third argument is a number that describes at what frequency we want to get count events.
* To turn off hooks, we call `sethook` with no arguments.

    ```
    debug.sethook(print, "l") -- print each line interpreter executes

    function trace (event, line)
      local s = debug.getinfo(2).short_src
      print(s .. ":" .. line)
    end
    debug.sethook(trace, "l") -- same, but more verbose
    ```

* A useful function to use with hooks is `debug.debug`. This simple function gives us a prompt that executes arbitrary Lua commands.

## Profiles

* See: Figure 25.2. Hook for counting number of calls (hook.lua)
* See: Figure 25.3. Getting the name of a function (hook.lua)

## Sandboxing

* Reflection, in the form of debug hooks, provides an interesting approach to curb denial of service (DoS) attacks.
* A first step is to use a count hook to limit the number of instructions that a chunk can execute.
* See: Figure 25.4. A naive sandbox with hooks (sandbox1.lua)
* One improvement is to check and limit memory use in the step function.
* Figure 25.5. Controlling memory use (sandbox2.lua)
* A subtler problem is the string library. We can call any function from this library as a method on a string. Therefore, we can call these functions even if they are not in the environment; literal strings smuggle them into our sandbox.
* See: Figure 25.6. Using hooks to bar calls to unauthorized functions (sandbox3.lua)
