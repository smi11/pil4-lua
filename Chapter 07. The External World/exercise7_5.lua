#!/usr/bin/env lua

--[=[

  Exercise 7.5: Generalize the previous program so that it prints the last n
  lines of a text file. Again, try to avoid reading the entire file when the
  file is large and seekable.

--]=]

local plines = assert(tonumber(arg[1]),"Please, specify number of lines as first argument")
local f_in  = assert(io.open(arg[2] or "", "r"), "Please, specify some valid text file as second argument")

function fsize (file)
  local current = file:seek() -- save current position
  local size = file:seek("end") -- get file size
  file:seek("set", current) -- restore position
  return size
end

local size = fsize(f_in)
local blocksize = 512    -- seems sane value, but it could be any size
local blocks = 0
local lines

repeat
  blocks = blocks + 1
  if blocksize*blocks < size then
    f_in:seek("end",-blocksize*blocks) -- seek in increments of blocksize from end backwards
  else
    f_in:seek("set")                   -- or seek to beginning of file
  end
  lines = {}
  for line in f_in:lines() do          -- read all lines until eof
    lines[#lines+1] = line
  end
until #lines > plines+1 or blocks*blocksize >= size  -- we need at least 1 more line to assure
                                                     -- plines number of lines are actually complete

f_in:close()   -- close file

-- print requested lines

local start = #lines-plines+1 > 0 and #lines-plines+1 or 1

for i = start, #lines do
  print(lines[i])
end
