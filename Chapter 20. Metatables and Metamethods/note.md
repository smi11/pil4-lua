---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 20. Metatables and Metamethods
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 20. Metatables and Metamethods

* Metatables allow us to change the behavior of a value when confronted with an unknown operation.
* Using metatables, we can define how Lua computes the expression `a + b`, where `a` and `b` are tables.
* Whenever Lua tries to add two tables, it checks whether either of them has a metatable and whether this metatable has an `__add` field. If Lua finds this field, it calls the corresponding value — the so-called metamethod, which should be a function — to compute the sum.
* We can think about metatables as a restricted kind of classes, in object-oriented terminology.
* Each value in Lua can have a metatable. Tables and userdata have individual metatables; values of other types share one single metatable for all values of that type.
* From Lua, we can set the metatables only of tables; to manipulate the metatables of values of other types we must use C code or the debug library.

## Arithmetic Metamethods

* we add to the metatable the metamethod `__add`, a field that describes how to perform the addition

    ```
    mt.__add = Set.union
    mt.__mul = Set.intersection
    print(Set.tostring((s1 + s2)*s1)) --> {10, 20, 30, 50}
    ```

* For each arithmetic operator there is a corresponding metamethod name.
* Besides addition and multiplication, there are metamethods for subtraction `__sub`, float division `__div`, floor division `__idiv`, negation `__unm`, modulo `__mod`, and exponentiation `__pow`.
* Similarly, there are metamethods for all bitwise operations: bitwise AND `__band`, OR `__bor`, exclusive OR `__bxor`, NOT `__bnot`, left shift `__shl`, and right shift `__shr`.
* We may define also a behavior for the concatenation operator, with the field `__concat`.

    ```
    s = Set.new{1,2,3}
    s = s + 8
    ```

* When looking for a metamethod, Lua performs the following steps: if the first value has a metatable with the required metamethod, Lua uses this metamethod, independently of the second value; otherwise, if the second value has a metatable with the required metamethod, Lua uses it; otherwise, Lua raises an error. Therefore, the last example will call `Set.union`, as will the expressions `10 + s` and `"hello" + s` (because both numbers and strings do not have a metamethod `__add`).
* Lua does not care about these mixed types.
* If we run the `s = s + 8` example, we will get an error inside the function Set.union
* we must check the type of the operands explicitly before attempting to perform the operation:

    ```
    if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
      error("attempt to 'add' a set with a non-set value", 2)
    end
    ```

## Relational Metamethods

* Metatables also allow us to give meaning to the relational operators, through the metamethods `__eq` (equal to), `__lt` (less than), and `__le` (less than or equal to).
* There are no separate metamethods for the other three relational operators: Lua translates `a ~= b` to `not (a == b)`, `a > b` to `b < a`, and `a >= b` to `b <= a`.
* The equality comparison has some restrictions. If two objects have different basic types, the equality operation results in false, without even calling any metamethod. So, a set will always be different from a number, no matter what its metamethod says.

## Library-Defined Metamethods

* It is a common practice for libraries to define and use their own fields in metatables.
* The function print always calls tostring to format its output.
* However, when formatting any value, tostring first checks whether the value has a `__tostring` metamethod. In this case, tostring calls the metamethod to do its job.

    `mt.__tostring = Set.tostring`

* The functions setmetatable and getmetatable also use a metafield, in this case to protect metatables.
*  If we set a `__metatable` field in the metatable, getmetatable will return the value of this field, whereas setmetatable will raise an error.

    ```
    mt.__metatable = "not your business"
    s1 = Set.new{}
    print(getmetatable(s1)) --> not your business
    setmetatable(s1, {})
      stdin:1: cannot change protected metatable
    ```

* Since Lua 5.2, pairs also have a metamethod, so that we can modify the way a table is traversed and add a traversal behavior to non-table objects.

## Table-Access Metamethods

* The metamethods for arithmetic, bitwise, and relational operators all define behavior for otherwise erroneous situations; they do not change the normal behavior of the language.
* Lua also offers a way to change the behavior of tables for two normal situations, the access and modification of absent fields in a table.

## The `__index` metamethod

* When we access an absent field in a table, the result is nil.
* Such accesses trigger the interpreter to look for an `__index` metamethod: if there is no such method, as usually happens, then the access results in nil; otherwise, the metamethod will provide the result.
* The archetypal example here is inheritance.

    ```
    -- create the prototype with default values
    prototype = {x = 0, y = 0, width = 100, height = 100}
    mt.__index = function (_, key)
      return prototype[key]
    end
    ```

* The use of the `__index` metamethod for inheritance is so common that Lua provides a shortcut.
* Despite being called a method, the `__index` metamethod does not need to be a function: it can be a table, instead.

    `mt.__index = prototype`

* The use of a table as an `__index` metamethod provides a fast and simple way of implementing single inheritance.
* A function, although more expensive, provides more flexibility: we can implement multiple inheritance, caching, and several other variations.
* When we want to access a table without invoking its `__index` metamethod, we use the function `rawget`.

## The `__newindex` metamethod

* The `__newindex` metamethod does for table updates what `__index` does for table accesses.
* The combined use of the `__index` and `__newindex` metamethods allows several powerful constructs in Lua, such as read-only tables, tables with default values, and inheritance for object-oriented programming.

## Tables with default values

* The default value of any field in a regular table is nil. It is easy to change this default value with metatables:

    ```
    function setDefault (t, d)
      local mt = {__index = function () return d end}
      setmetatable(t, mt)
    end
    ```

* After the call to `setDefault`, any access to an absent field in tab calls its `__index` metamethod, which returns zero (the value of d for this metamethod).
* The function `setDefault` creates a new closure plus a new metatable for each table that needs a default value. This can be expensive if we have many tables that need default values.
* If we are not worried about name clashes, we can use a key like "___" for our exclusive field:

    ```
    local mt = {__index = function (t) return t.___ end}
    function setDefault (t, d)
      t.___ = d
      setmetatable(t, mt)
    end
    ```

* Note that now we create the metatable mt and its corresponding metamethod only once, outside `SetDefault`.
* If we are worried about name clashes, it is easy to ensure the uniqueness of the special key:

    ```
    local key = {} -- unique key
    local mt = {__index = function (t) return t[key] end}
    function setDefault (t, d)
      t[key] = d
      setmetatable(t, mt)
    end
    ```

* An alternative approach for associating each table with its default value is a technique I call dual representation, which uses a separate table where the indices are the tables and the values are their default values.
* Another alternative is to memorize metatables in order to reuse the same metatable for tables with the same default.

## Tracking table accesses

* Suppose we want to track every single access to a certain table. Both `__index` and `__newindex` are relevant only when the index does not exist in the table.
* The only way to catch all accesses to a table is to keep it empty and use that empty table as a proxy for table we want to track.
* If we want to monitor several tables, we do not need a different metatable for each one. Instead, we can somehow map each proxy to its original table and share a common metatable for all proxies.

## Read-only tables

```
function readOnly (t)
  local proxy = {}
  local mt = { -- create metatable
    __index = t,
    __newindex = function (t, k, v)
      error("attempt to update a read-only table", 2)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
print(days[1]) --> Sunday
days[2] = "Noday"
--> stdin:1: attempt to update a read-only table
```
