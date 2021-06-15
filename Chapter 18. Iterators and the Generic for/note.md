---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter:  18. Iterators and the Generic for
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 18. Iterators and the Generic for

## Iterators and Closures

* An iterator is any construction that allows us to iterate over the elements of a collection
* In Lua, we typically represent iterators by functions: each time we call the function, it returns the “next” element from the collection
* Any iterator needs to keep some state between successive calls
* For our own iterators, closures provide an excellent mechanism for keeping state
* A closure construction typically involves two functions: the closure itself and a factory
* We can use iterator in a `while` loop
* However, it is easier to use the generic `for`

## The Semantics of the Generic `for`

* `for` keeps internally three values: the iterator function, an invariant state, and a control variable
* We call the first (or only) variable in the list the control variable. Its value is never nil during the loop, because when it becomes nil the loop ends

    ```
    -- this construct is
    for var_1, ..., var_n in explist do block end

    -- equivalent to the following code:
    do
      local _f, _s, _var = explist
      while true do
        local var_1, ... , var_n = _f(_s, _var)
        _var = var_1
        if _var == nil then break end
        block
      end
    end
    ```

* if our iterator function is f, the invariant state is s, and the initial value for the control variable is a 0, the control variable will loop over the values a 1 = f(s, a0 ), a2 = f(s, a1 ), and so on, until ai is nil. If the for has other variables, they simply get the extra values returned by each call to f.

## Stateless Iterators

* A stateless iterator is an iterator that does not keep any state by itself
* `for` loop calls its iterator function with two arguments: the invariant state and the control variable. A stateless iterator generates the next element for the iteration using only these two values.
* When Lua calls `ipairs(t)` in a for loop, it gets three values: the function `iter` as the iterator, the table `t` as the invariant state, and zero as the initial value for the control variable. Then, Lua calls `iter(t, 0)`, which results in 1,t\[1\] (unless t\[1\] is already nil). In the second iteration, Lua calls `iter(t, 1)`, which results in 2,t\[2\], and so on, until the first nil element.
* The function pairs, which iterates over all elements of a table, is similar, except that its iterator function is `next`

## Traversing Tables in Order

* In a table, the entries form a set, and have no order whatsoever. If we want to order them, we have to copy the keys to an array and then sort the array.
* If we traverse this table with pairs, the names appear in an arbitrary order. We cannot sort them directly, because these names are keys of the table.
* However, when we put them into an array, then we can sort them.
* The factory function pairsByKeys first collects the keys into an array, then it sorts the array, and finally it returns the iterator function.

## True Iterators

* The name “iterator” is a little misleading, because our iterators do not iterate: what iterates is the for loop. Iterators only provide the successive values for the iteration.
* However, there is another way to build iterators wherein iterators actually do the iteration.
* We simply call the iterator with an argument that describes what the iterator must do at each iteration. More specifically, the iterator receives as argument a function that it calls inside its loop.
* To use this iterator, we must supply the loop body as a function. For example:

    `allwords(print)`

* Often, we use an anonymous function as the body.
* True iterators were popular in older versions of Lua, when the language did not have the for statement.
* It is easier to write the iterator with true iterators. On the other hand, the generator style is more flexible.
* Generator allows two or more parallel iterations. True iterators do not.
* Second, it allows the use of `break` and `return` inside the iterator body.
