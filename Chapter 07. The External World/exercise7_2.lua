#!/usr/bin/env lua

--[=[

  Exercise 7.2: Change the previous program so that it asks for confirmation if
  the user gives the name of an existing file for its output.

--]=]

-- return true if safe to overwrite existing file or false if not
function safe2overwrite(fn)
  if not fn then  -- if called without file name just signal okay
    return true
  end
  local exist = io.open(fn,"r")  -- try to open file in readonly mode
  if exist then
    -- file exists, so close it and ask for confirmation to overwrite
    exist:close()
    io.write(string.format("File %s exists. Do you want to overwrite it? (y/n)", fn))
    local confirm = io.read()
    return confirm == "y" or confirm == "Y"
  end
  return true
end

-- set input stream to either file named arg[1] or to io.stdin
local f_in  = arg[1] and assert(io.open(arg[1], "r")) or io.stdin

-- set output stream to either file named arg[2] or to io.stdout
local f_out = arg[2] and safe2overwrite(arg[2]) and assert(io.open(arg[2], "w")) or io.stdout

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
