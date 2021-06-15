---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 6. Functions
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 6. Functions

* Functions are the main mechanism for abstraction of statements and expressions in Lua.
* We can use a function call as a statement or we use it as an expression that return values.
* In both cases, a list of arguments enclosed in parentheses denotes the call; if the call has no arguments, we still must write an empty list () to denote it.

```
print(8*9, 9/8)
a = math.sin(3) + math.cos(10)
print(os.date())

print "Hello World"   <--> print("Hello World")
dofile 'a.lua'        <--> dofile ('a.lua')
print [[a multi-line  <--> print([[a multi-line
 message]]                  message]])
f{x=10, y=20}         <--> f({x=10, y=20})
type{}                <--> type({})

function f (a, b) print(a, b) end
f()         --> nil nil
f(3)        --> 3 nil
f(3, 4)     --> 3 4
f(3, 4, 5)  --> 3 4 (5 is discarded)
```

## Multiple Results

* In Lua functions can return multiple results.

```
s, e = string.find("hello Lua users", "Lua")
print(s, e) --> 7 9

function foo0 () end                    -- returns no results
function foo1 () return "a" end         -- returns 1 result
function foo2 () return "a", "b" end    -- returns 2 results

x, y = foo2()                           -- x="a", y="b"
x = foo2()                              -- x="a", "b" is discarded
x, y, z = 10, foo2()                    -- x=10, y="a", z="b"

x,y = foo0()                            -- x=nil, y=nil
x,y = foo1()                            -- x="a", y=nil
x,y,z = foo2()                          -- x="a", y="b", z=nil

x,y = foo2(), 20                        -- x="a", y=20 ('b' discarded)
x,y = foo0(), 20, 30                    -- x=nil, y=20 (30 is discarded)

print(foo0())                           --> (no results)
print(foo1())                           --> a
print(foo2())                           --> a b
print(foo2(), 1)                        --> a 1
print(foo2() .. "x")                    --> ax (see next)

t = {foo0()}                            -- t = {} (an empty table)
t = {foo1()}                            -- t = {"a"}
t = {foo2()}                            -- t = {"a", "b"}

t = {foo0(), foo2(), 4}                 -- t[1] = nil, t[2] = "a", t[3] = 4

function foo (i)
  if i == 0 then return foo0()
  elseif i == 1 then return foo1()
  elseif i == 2 then return foo2()
  end
end

print(foo(1))           --> a
print(foo(2))           --> a b
print(foo(0))           -- (no results)
print(foo(3))           -- (no results)

print((foo0()))         --> nil
print((foo1()))         --> a
print((foo2()))         --> a
```

## Variadic Functions

* A function in Lua can be variadic, that is, it can take a variable number of arguments.
* Variadic functions can have any number of fixed parameters before the variadic part.
* To iterate over its extra arguments, a function can use the expression `{...}` to collect them all in a table.
* However, in the rare occasions when the extra arguments can be valid nils, the table created with `{...}` may not be a proper sequence.
* For these occasions, Lua offers the function `table.pack`.
* This function receives any number of arguments and returns a new table with all its arguments (just like `{...}`), but this table has also an extra field "n", with the total number of arguments.

```
function foo1 (...)
  print("calling foo:", ...)
  return foo(...)
end

function fwrite (fmt, ...)
  return io.write(string.format(fmt, ...))
end

function nonils (...)
  local arg = table.pack(...)
  for i = 1, arg.n do
    if arg[i] == nil then return false end
  end
  return true
end

print(nonils(2,3,nil))  --> false
print(nonils(2,3))      --> true
print(nonils())         --> true
print(nonils(nil))      --> false

print(select(1, "a", "b", "c"))       --> a b c
print(select(2, "a", "b", "c"))       --> b c
print(select(3, "a", "b", "c"))       --> c
print(select("#", "a", "b", "c"))     --> 3
```

## The function `table.unpack`

* `table.unpack` takes a list and returns as results all elements from the list.
* An important use for unpack is in a generic call mechanism. A generic call mechanism allows us to call any function, with any arguments, dynamically.

```
print(table.unpack{10,20,30})   --> 10 20 30
a,b = table.unpack{10,20,30}    -- a=10, b=20, 30 is discarded

print(string.find("hello", "ll"))
f = string.find
a = {"hello", "ll"}
print(f(table.unpack(a)))

print(table.unpack({"Sun", "Mon", "Tue", "Wed"}, 2, 3))
--> Mon Tue
```

## Proper Tail Calls

* Lua does tail-call elimination - is properly tail recursive.
* A tail call is a goto dressed as a call. A tail call happens when a function calls another as its last action, so it has nothing else to do.

```
-- tail call
function f (x) x = x + 1; return g(x) end

-- does not consume stack, any n is acceptable
function foo (n)
  if n > 0 then return foo(n - 1) end
end

-- not a tail call
function f (x) g(x) end

-- no tail calls
return g(x) + 1   -- must do the addition
return x or g(x)  -- must adjust to 1 result
return (g(x))     -- must adjust to 1 result

-- tail call ok
return x[i].foo(x[j] + a*b, i + j)
```
