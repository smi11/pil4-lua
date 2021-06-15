#!/usr/bin/env lua

--[=[

  Exercise 7.4: Write a program that prints the last line of a text file. Try to
  avoid reading the entire file when the file is large and seekable.

--]=]

local blocksize = 1024    -- seems sane value, but it could be any size

local f_in  = assert(io.open(arg[1] or "", "r"), "Please specify some valid text file as argument")

function fsize (file)
  local current = file:seek() -- save current position
  local size = file:seek("end") -- get file size
  file:seek("set", current) -- restore position
  return size
end

local size = fsize(f_in)
local blocks = 1
local lines

repeat
  if size > blocksize then
    f_in:seek("end",-blocksize*blocks) -- seek in increments of blocksize from end backwards
  else
    f_in:seek("set")              -- file is smaller than blocksize, seek to beginning of file
  end
  lines = {}
  for line in f_in:lines() do     -- read all lines until eof
    lines[#lines+1] = line
  end
  blocks = blocks + 1
until #lines > 2 or blocks*blocksize >= size  -- if we have at least 2 lines then the last
                                              -- line is certainly complete

f_in:close()   -- only actual files will be closed 

print(lines[#lines])
