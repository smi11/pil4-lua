---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 15. Data Files and Serialization
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 15. Data Files and Serialization

## Data Files

* Table constructors provide an interesting alternative for file formats.
* The technique is to write our data file as Lua code that, when run, rebuilds the data into the program.

```
Entry{"Donald E. Knuth", "Literate Programming", "CSLI", 1992}
Entry{"Jon Bentley", "More Programming Pearls", "Addison-Wesley", 1990}

local count = 0
function Entry ()
  count = count + 1
end
dofile("data")
print("number of entries: " .. count)

---

Entry{ author = "Donald E. Knuth", title = "Literate Programming", publisher = "CSLI", year = 1992 }
Entry{ author = "Jon Bentley", title = "More Programming Pearls", year = 1990, publisher = "Addison-Wesley", }

local authors = {} -- a set to collect authors
function Entry (b)
  authors[b.author or "unknown"] = true
end
dofile("data")
for name in pairs(authors) do print(name) end
```

## Serialization

* Frequently we need to serialize some data, that is, to convert the data into a stream of bytes or characters, so that we can save it into a file or send it through a network connection.
* We can represent serialized data as Lua code in such a way that, when we run the code, it reconstructs the saved values into the reading program.

```
function serialize (o)
  local t = type(o)
  if t == "number" or t == "string" or t == "boolean" or t == "nil" then
    io.write(string.format("%q", o))
  else
    other cases
  end
end
```

* See quoting.lua

## Saving tables without cycles

* See nocycles.lua

## Saving tables with cycles

* See cycles.lua
