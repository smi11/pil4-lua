---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 5. Tables
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 5. Tables

* Tables are the main and only data structuring mechanism in Lua.
* We use tables to represent arrays, sets, records, and many other data structures in a simple, uniform, and efficient way.
* A table in Lua is essentially an associative array. A table is an array that accepts not only numbers as indices, but also strings or any other value of the language (except nil).
* Tables in Lua are neither values nor variables; they are _objects_.

```
> a = {}                -- create a table and assign its reference
> k = "x"
> a[k] = 10             -- new entry, with key="x" and value=10
> a[20] = "great"       -- new entry, with key=20 and value="great"
> a["x"]                --> 10
> k = 20
> a[k]                  --> "great"
> a["x"] = a["x"] + 1   -- increments entry "x"
> a["x"]                --> 11

> a = {}
> a["x"] = 10
> b = a                 -- 'b' refers to the same table as 'a'
> b["x"]                --> 10
> b["x"] = 20
> a["x"]                --> 20
> a = nil               -- only 'b' still refers to the table
> b = nil               -- no references left to the table
```

## Table Indices

* Each table can store values with different types of indices, and it grows as needed to accommodate new entries.
* Like global variables, table fields evaluate to nil when not initialized.
* We can assign nil to a table field to delete it.

```
> a = {}                -- empty table
> -- create 1000 new entries
> for i = 1, 1000 do a[i] = i*2 end
> a[9]                  --> 18
> a["x"] = 10
> a["x"]                --> 10
> a["y"]                --> nil

> a = {}                -- empty table
> a.x = 10              -- same as a["x"] = 10
> a.x --> 10            -- same as a["x"]
> a.y --> nil           -- same as a["y"]

> a = {}
> x = "y"
> a[x] = 10             -- put 10 in field "y"
> a[x] --> 10           -- value of field "y"
> a.x --> nil           -- value of field "x" (undefined)
> a.y --> 10            -- value of field "y"

> i = 10; j = "10"; k = "+10"
> a = {}
> a[i] = "number key"
> a[j] = "string key"
> a[k] = "another string key"
> a[i]                  --> number key
> a[j]                  --> string key
> a[k]                  --> another string key
> a[tonumber(j)]        --> number key
> a[tonumber(k)]        --> number key

> a = {}
> a[2.0] = 10
> a[2.1] = 20
> a[2]                  --> 10
> a[2.1]                --> 20
```

## Table Constructors

* Constructors are expressions that create and initialize tables.

```
days = {"Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"}
print(days[4])        --> Wednesday

a = {x = 10, y = 20}
-- is equal to
a = {}; a.x = 10; a.y = 20

w = {x = 0, y = 0, label = "console"}
x = {math.sin(0), math.sin(1), math.sin(2)}
w[1] = "another field"      -- add key 1 to table 'w'
x.f = w                     -- add key "f" to table 'x'
print(w["x"])               --> 0
print(w[1])                 --> another field
print(x.f[1])               --> another field
w.x = nil                   -- remove field "x"

polyline = {color="blue",
            thickness=2,
            npoints=4,
            {x=0, y=0},   -- polyline[1]
            {x=-10, y=0}, -- polyline[2]
            {x=-10, y=1}, -- polyline[3]
            {x=0, y=1}    -- polyline[4]
           }

print(polyline[2].x)      --> -10
print(polyline[4].y)      --> 1

opnames = {["+"] = "add", ["-"] = "sub",
           ["*"] = "mul", ["/"] = "div"}

i = 20; s = "-"
a = {[i+0] = s, [i+1] = s..s, [i+2] = s..s..s}

print(opnames[s])         --> sub
print(a[22])              --> ---

{x = 0, y = 0}  <--> {["x"] = 0, ["y"] = 0}
{"r", "g", "b"} <--> {[1] = "r", [2] = "g", [3] = "b"}

a = {[1] = "red", [2] = "green", [3] = "blue",} -- comma at the end is ok
```

## Arrays, Lists, and Sequences

* To represent a conventional array or a list, we simply use a table with integer keys.
* For sequences, Lua offers the length operator (#).
* The length operator is unreliable for lists with holes (nils).

```
-- read 10 lines, storing them in a table
a = {}
for i = 1, 10 do
  a[i] = io.read()
end

-- print the lines, from 1 to #a
for i = 1, #a do
  print(a[i])
end

a[#a + 1] = v -- appends 'v' to the end of the sequence

a = {}
a[1] = 1
a[2] = nil -- does nothing, as a[2] is already nil
a[3] = 1
a[4] = 1

a = {10, 20, 30, nil, nil}
-- is equal to
a = {10, 20, 30}
```

## Table Traversal

* We can traverse all key–value pairs in a table with the `pairs` iterator.
* The order that elements appear in a traversal is undefined.
* For lists, we can use the `ipairs` iterator, which is naturally ordered.

```
t = {10, print, x = 12, k = "hi"}
for k, v in pairs(t) do
  print(k, v)
end
--> 1 10
--> k hi
--> 2 function: 0x420610
--> x 12

t = {10, print, 12, "hi"}
for k, v in ipairs(t) do
  print(k, v)
end
--> 1 10
--> 2 function: 0x420610
--> 3 12
--> 4 hi

t = {10, print, 12, "hi"}
for k = 1, #t do
  print(k, t[k])
end
--> 1 10
--> 2 function: 0x420610
--> 3 12
--> 4 hi
```

## Safe Navigation

```
-- cumbersome and not efficient
zip = company and company.director and
      company.director.address and
      company.director.address.zipcode

-- better
zip = (((company or {}).director or {}).address or {}).zipcode

-- even better
E = {} -- can be reused in other similar expressions
zip = (((company or E).director or E).address or E).zipcode
```

## The Table Library

```
t = {}
for line in io.lines() do
  table.insert(t, line)
end
print(#t)     --> (number of lines read)

print(table.remove(t))   -- print and remove last element
print(table.remove(t,1)) -- print and remove first element shifting other elements

-- insert element at the beginning of table
table.move(a, 1, #a, 2)    -- Lua 5.3+
a[1] = newElement

-- remove first element
table.move(a, 2, #a, 1)
a[#a] = nil               -- erase last item
```
