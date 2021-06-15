---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 23. Garbage
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 23. Garbage

* Programs can create objects (tables, closures, etc.), but there is no function to delete objects.
* Lua automatically deletes objects that become garbage, using garbage collection.
* Weak tables, finalizers, and the function collectgarbage are the main mechanisms that we can use in Lua to help the garbage collector.

## Weak Tables

* Weak tables are the mechanism that we use to tell Lua that a reference should not prevent the reclamation of an object.
* A weak reference is a reference to an object that is not considered by the garbage collector.
* If all references pointing to an object are weak, the collector will collect the object and delete these weak references.
* If an object is held only in weak tables, Lua will eventually collect the object.

* Under normal circumstances, the garbage collector does not collect objects that appear as keys or as values of an accessible table - both keys and values are strong references.
* In a weak table, both keys and values can be weak.
* This means that there are three kinds of weak tables: tables with weak keys, tables with weak values, and tables where both keys and values are weak.
* Irrespective of the kind of table, when a key or a value is collected the whole entry disappears from the table.
* The weakness of a table is given by the field __mode of its metatable.
* Only objects can be removed from a weak table. Values, such as strings, numbers and Booleans, are not collectible.

## Memorize Functions

```
local results = {}
setmetatable(results, {__mode = "v"}) -- make values weak
-- because the indices are always strings, we can make this table fully weak
-- setmetatable(results, {__mode = "kv"})
function mem_loadstring (s)
  local res = results[s]
  if res == nil then      -- result not available?
    res = assert(load(s)) -- compute new result
    results[s] = res      -- save for later reuse
  end
  return res
end
```

*  If the results table has weak values, each garbage-collection cycle will remove all translations not in use at that moment (which means virtually all of them).

## Object Attributes

* Another important use of weak tables is to associate attributes with objects.
* An external table provides an ideal way to map attributes to objects - a dual representation.
* We use the objects as keys, and their attributes as values.

## Revisiting Tables with Default Values

* In the first solution, we use a weak table to map each table to its default value.
* We use `defaults[t]` to represent `t.default`.
* In the second solution, we use distinct metatables for distinct default values.

    `setmetatable(t, {__index = function () return d end})`

* In this case, we use weak values to allow the collection of metatables that are not being used anymore.

## Ephemeron Tables

* A tricky situation occurs when, in a table with weak keys, a value refers to its own key.
* see Figure 23.1. Constant-function factory with memorization
* The value (the constant function) associated with an object in mem refers back to its own key (the object itself).
* Because values are not weak, there is always a strong reference to each function.
* In Lua, a table with weak keys and strong values is an ephemeron table.
* In an ephemeron table, the accessibility of a key controls the accessibility of its corresponding value.

## Finalizers

* A finalizer is a function associated with an object that is called when that object is about to be collected.

    ```
    o = {x = "hi"}
    setmetatable(o, {__gc = function (o) print(o.x) end})
    o = nil
    collectgarbage() --> hi
    ```

* mt.__gc field must be set before setmetatable(o, mt). It could only be set to placeholder like "true" and later changed to actuall function.
* When the collector finalizes several objects in the same cycle, it calls their finalizers in the reverse order that the objects were marked for finalization.
* Another tricky point about finalizers is resurrection. When a finalizer is called, it gets the object being finalized as a parameter. So, the object becomes alive again, at least during the finalization.
* Because of resurrection, Lua collects objects with finalizers in two phases.
* If we want to ensure that all garbage in our program has been actually released, we must call collectgarbage twice; the second call will delete the objects that were finalized during the first call.

    ```
    local t = {__gc = function ()  -- your 'atexit' code comes here
      print("finishing Lua program")
    end}
    setmetatable(t, t)
    _G["*AA*"] = t
    ```

## The Garbage Collector

* In version 5.1, Lua got an incremental collector. This collector performs the same steps as the old one, but it does not need to stop the world while it runs. Instead, it runs interleaved with the interpreter.
* Every time the interpreter allocates some amount of memory, the collector runs a small step.
* Lua 5.2 introduced emergency collection. When a memory allocation fails, Lua forces a full collection cycle and tries again the allocation

## Controlling the Pace of Collection

* The function `collectgarbage` allows us to exert some control over the garbage collector.
