#!/usr/bin/env lua

--[=[

  Exercise 7.3: Compare the performance of Lua programs that copy the standard
  input stream to the standard output stream in the following ways:

  • byte by byte;
  • line by line;
  • in chunks of 8 kB;
  • the whole file at once.

  For the last option, how large can the input file be?

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

-- set output stream for writing to either file named arg[2] or to io.stdout
local f_out = arg[2] and safe2overwrite(arg[2]) and assert(io.open(arg[2], "w")) or io.stdout


-- Byte by byte

local tstart = os.clock()

while true do
  local block = f_in:read(1) -- byte by byte
  if not block then break end
  f_out:write(block)
end

f_out:flush()

io.write("Byte-by-byte: ", os.clock()-tstart,"\n")

f_in:seek("set")  -- rewind streams back to beginning
f_out:seek("set")

-- Line by line

local tstart = os.clock()

while true do
  local block = f_in:read("L") -- line (keep newline)
  if not block then break end
  f_out:write(block)
end

f_out:flush()

io.write("Line-by-line: ", os.clock()-tstart,"\n")

f_in:seek("set")  -- rewind streams back to beginning
f_out:seek("set")

-- 8kB chunks

local tstart = os.clock()

while true do
  local block = f_in:read(2^13) -- 8kB chunks
  if not block then break end
  f_out:write(block)
end

f_out:flush()

io.write("8kB chunks: ", os.clock()-tstart,"\n")

f_in:seek("set")  -- rewind streams back to beginning
f_out:seek("set")

-- 8kB chunks

local tstart = os.clock()

local block = f_in:read("a") -- whole file
f_out:write(block)

f_out:flush()

io.write("Whole file: ", os.clock()-tstart,"\n")

f_in:close()   -- only actual files will be closed 
f_out:close()  -- io.stdin and io.stdout will stay open

-- Copy performane on 58.647 kB file:

--> Byte-by-byte: 37.096
--> Line-by-line: 2.855
--> 8kB chunks: 0.078000000000003
--> Whole file: 0.188

-- Best performance is copying in chunks of 8 kB. If we copy whole file at once,
-- we need to allocate as much memory as size of the file. Hence the slowdown.

-- I managed to load file with size 3.047.908 kB on my Windows 7, 4GB RAM PC. 
-- File size 4.404.448 kB was too big and Lua reported not enough memory
-- for buffer allocation.
