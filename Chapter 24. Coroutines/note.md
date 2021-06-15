---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 24. Coroutines
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 24. Coroutines

* Coroutines can turn upside-down the relationship between callers and callees
* A coroutine is similar to a thread (in the sense of multithreading): it is a line of execution, with its own stack, its own local variables, and its own instruction pointer; it shares global variables and mostly anything else with other coroutines.

## Coroutine Basics

* Lua packs all its coroutine-related functions in the table coroutine. The function `create` creates new coroutines. It has a single argument, a function with the code that the coroutine will run (the coroutine body).

    co = coroutine.create(function () print("hi") end)
    print(type(co)) --> thread
    print(coroutine.status(co)) --> suspended
    coroutine.resume(co) --> hi
    print(coroutine.status(co)) --> dead

* `resume` runs in protected mode, like `pcall`
* A useful facility in Lua is that a pair resume–yield can exchange data.

    ```
    co = coroutine.create(function (a, b, c)
      print("co", a, b, c + 2)
    end)
    coroutine.resume(co, 1, 2, 3) --> co 1 2 5
    ```

* A call to coroutine.resume returns, after the true that signals no errors, any arguments passed to the corresponding yield

    ```
    co = coroutine.create(function (a,b)
      coroutine.yield(a + b, a - b)
    end)
    print(coroutine.resume(co, 20, 10)) --> true 30 10
    ```

* Lua offers what we call asymmetric coroutines.
* This means that it has a function to suspend the execution of a coroutine and a different function to resume a suspended coroutine.

## Who Is the Boss?

* One of the most paradigmatic examples of coroutines is the producer–consumer problem.
* Coroutines provide an ideal tool to match producers and consumers without changing their structure, because a resume–yield pair turns upside-down the typical relationship between the caller and its callee.
* When a coroutine calls yield, it does not enter into a new function; instead, it returns a pending call (to resume). Similarly, a call to resume does not start a new function, but returns a call to yield. This property is exactly what we need to match a send with a receive in such a way that each one acts as if it were the master and the other the slave.
* When the consumer needs an item, it resumes the producer, which runs until it has an item to give to the consumer, and then stops until the consumer resumes it again.

## Coroutines as Iterators

* We can write iterators without worrying about how to keep state between successive calls.
* see permgen-cl.lua
* The function `permutations` uses a common pattern in Lua, which packs a call to resume with its corresponding coroutine inside a function.
* This pattern is so common that Lua provides a special function for it: `coroutine.wrap`.

## Event-Driven Programming

* In a typical event-driven platform, an external entity generates events to our program in a so-called event loop (or run loop).
* Coroutines allow us to reconcile our loops with the event loop.
* The key idea is to run our main code as a coroutine that, at each request to the library, sets the callback as a function to resume itself and then yields.
