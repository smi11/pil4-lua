#!/usr/bin/env lua

--[=[

  Exercise 7.1: Write a program that reads a text file and rewrites it with its
  lines sorted in alphabetical order. When called with no arguments, it should
  read from standard input and write to standard output. When called with one
  file-name argument, it should read from that file and write to standard
  output. When called with two file-name arguments, it should read from the
  first file and write to the second.

--]=]

-- set input stream to either file named arg[1] or to io.stdin
local f_in  = arg[1] and assert(io.open(arg[1], "r")) or io.stdin

-- set output stream to either file named arg[2] or to io.stdout
local f_out = arg[2] and assert(io.open(arg[2], "w")) or io.stdout

local lines = {}

-- when reading from stdin type Ctrl-D (Linux) or Ctrl-Z (Windows) to signal EOF

-- read the file/stream into table 'lines'
for line in f_in:lines() do
  lines[#lines + 1] = line
end

-- sort
table.sort(lines)

-- write all the lines
for _, l in ipairs(lines) do
  f_out:write(l, "\n")
end

-- close file handles
f_in:close()   -- only actual files will be closed 
f_out:close()  -- io.stdin and io.stdout will stay open
