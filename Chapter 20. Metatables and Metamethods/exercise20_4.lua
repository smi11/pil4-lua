--[=[

  Exercise 20.4: Proxy tables can represent other kinds of objects besides
  tables, file as array. Write a function fileAsArray that takes the name of a
  file and returns a proxy to that file, so that after a call t =
  fileAsArray("myFile"), an access to t[i] returns the i-th byte of that file,
  and an assignment to t[i] updates its i-th byte.

--]=]

local function fileAsArray (filename)
  local proxy = {}
  local file = assert(io.open(filename,"r+"))

  local mt = {
    __index = function (t, pos)
      assert(pos>0, "Invalid file position")
      file:seek("set", pos-1)    -- first index is 1, but pos is 0
      return file:read(1)
    end,

    __newindex = function (t, pos, val)
      assert(pos>0, "Invalid file position")
      file:seek("set", pos-1)
      file:write(val)
    end,
  }

  return setmetatable(proxy, mt)
end

local f = fileAsArray("editme.txt")
local LEN = 53

for i = 1, LEN do
  io.write(f[i])
end
--> We will change this --> A to letter B and then back.

f[25] = "B" -- write B

for i = 1, LEN do
  io.write(f[i])
end
--> We will change this --> B to letter B and then back.

f[25] = "A" -- write back A

for i = 1, LEN do
  io.write(f[i])
end
--> We will change this --> A to letter B and then back.
