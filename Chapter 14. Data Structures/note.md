---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 14. Data Structures
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 14. Data Structures

* We can represent all structures that other languages offer — arrays, records, lists, queues, sets — with tables in Lua.

## Arrays

* We implement arrays in Lua simply by indexing tables with integers.

```
local a = {} -- new array
for i = 1, 1000 do
  a[i] = 0
end

-- The length operator (#) uses this fact to find the size of an array: 
print(#a) --> 1000
```

* We can start an array at index zero, one, or any other value. Default is 1.
* If our arrays do not start with one, # will not work correctly.

```
-- constructor to create and initialize arrays
squares = {1, 4, 9, 16, 25, 36, 49, 64, 81}
```

## Matrices and Multi-Dimensional Arrays

* There are two main ways to represent matrices in Lua.
* The first one is with a jagged array (an array of arrays), that is, a table wherein each element is another table.

```
local mt = {} -- create the matrix
for i = 1, N do
  local row = {} -- create a new row
  mt[i] = row
  for j = 1, M do
    row[j] = 0
  end
end
```

* The second way to represent a matrix is by composing the two indices into a single one.

```
local mt = {} -- create the matrix
for i = 1, N do
  local aux = (i - 1) * M
  for j = 1, M do
    mt[aux + j] = 0
  end
end
```

* Quite often, applications use a _sparse matrix_, a matrix wherein most elements are zero or nil.
* See mult.lua

## Linked Lists

We represent each node with a table; links are simply table fields that contain references to other tables.

```
list = nil

-- insert an element at the beginning of the list, with a value v
list = {next = list, value = v}

-- traverse the list
local l = list
while l do
  print(l.value)
  l = l.next 
end
```

## Queues and Double-Ended Queues

* See queue.lua

## Reverse Tables

```
days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
revDays = {["Sunday"] = 1, ["Monday"] = 2, ["Tuesday"] = 3, ["Wednesday"] = 4, ["Thursday"] = 5, ["Friday"] = 6, ["Saturday"] = 7}
x = "Tuesday"
print(revDays[x]) --> 3
```

## Sets and Bags

```
reserved = { ["while"] = true, ["if"] = true, ["else"] = true, ["do"] = true, }
for w in string.gmatch(s, "[%a_][%w_]*") do
  if not reserved[w] then do
    something with 'w' -- 'w' is not a reserved word
  end
end
```

```
function insert (bag, element)
  bag[element] = (bag[element] or 0) + 1
end

function remove (bag, element)
  local count = bag[element]
  bag[element] = (count and count > 1) and count - 1 or nil
end
```

## String Buffers

```
local t = {}
for line in io.lines() do
  t[#t + 1] = line
end
t[#t + 1] = ""
s = table.concat(t, "\n")
```

## Graphs

* See graph.lua
