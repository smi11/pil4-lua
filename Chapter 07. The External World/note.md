---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 7. The External World
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 7. The External World

* Pure Lua offers only the functionalities that the ISO C standard offers - namely, basic file manipulation plus some extras.

## The Simple I/O Model

* The simple model assumes a current input stream (stdin) and a current output stream (stdout), and its I/O operations operate on these streams.

```
> io.write("sin(3) = ", math.sin(3), "\n")
--> sin(3) = 0.14112000805987
> io.write(string.format("sin(3) = %.4f\n", math.sin(3)))
--> sin(3) = 0.1411

t = io.read("a")                  -- read the whole file
t = string.gsub(t, "bad", "good") -- do the job
io.write(t)                       -- write the file

-- mime quoted-printable encoding
t = io.read("all")
t = string.gsub(t, "([\128-\255=])", function (c)
  return string.format("=%02X", string.byte(c))
end)
io.write(t)

-- copy lines from stdin to stdout
for count = 1, math.huge do
  local line = io.read("L")
  if line == nil then break end
  io.write(string.format("%6d ", count), line)
end

-- copy with io.lines iterator
local count = 0
for line in io.lines() do
  count = count + 1
  io.write(string.format("%6d ", count), line, "\n")
end

-- copy in blocks
while true do
  local block = io.read(2^13) -- block size is 8K
  if not block then break end
  io.write(block)
end

-- read numbers (3 numbers per line)
while true do
  local n1, n2, n3 = io.read("n", "n", "n")
  if not n1 then break end
  print(math.max(n1, n2, n3))
end
```

## The Complete I/O Model

* The simple I/O model is convenient for simple things, but it is not enough for more advanced file manipulation, such as reading from or writing to several files simultaneously.

```
print(io.open("non-existent-file", "r"))
--> nil non-existent-file: No such file or directory 2

print(io.open("/etc/passwd", "w"))
--> nil /etc/passwd: Permission denied 13

local f = assert(io.open(filename, mode)) -- idiom for openning files

local f = assert(io.open(filename, "r"))
local t = f:read("a")
f:close()

io.stderr:write(message)

local temp = io.input()   -- save current stream
io.input("newinput")      -- open a new current stream
                          -- do something with new input
io.input():close()        -- close current stream
io.input(temp)            -- restore previous current stream

for block in io.input():lines(2^13) do
  io.write(block)
end
```

## Other Operations on Files

* The function `io.tmpfile` returns a stream over a temporary file, open in read/write mode. This file is automatically removed (deleted) when the program ends.
* The function `flush` executes all pending writes to a file.
* The `setvbuf` method sets the buffering mode of a stream.
* The `seek` method can both get and set the current position of a stream in a file. Its general form is `f:seek(whence, offset)`, where the whence parameter is a string that specifies how to interpret he offset.

```
function fsize (file)
  local current = file:seek() -- save current position
  local size = file:seek("end") -- get file size
  file:seek("set", current) -- restore position
  return size
end
```

* `os.rename` changes the name of a file and `os.remove` removes (deletes) a file. Note that these functions come from the os library, not the io library.

## Other System Calls

* The function `os.exit` terminates the execution of a program.
* The function `os.getenv` gets the value of an environment variable.

    `print(os.getenv("HOME")) --> /home/lua`

## Running system commands

```
function createDir (dirname)
  os.execute("mkdir " .. dirname)
end

-- for POSIX systems, use 'ls' instead of 'dir'
local f = io.popen("dir /B", "r")
local dir = {}
for entry in f:lines() do
  dir[#dir + 1] = entry
end
```
