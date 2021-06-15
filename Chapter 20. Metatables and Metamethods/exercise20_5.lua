--[=[

  Exercise 20.5: Extend the previous example to allow us to traverse the bytes
  in the file with pairs(t) and get the file length with #t.

--]=]

local function fileAsArray (filename)
  local proxy = {}
  local file = assert(io.open(filename,"r+"))

  local function fnext(t, i) -- stateless iterator
    i = i + 1
    local c = t[i] -- t[i] will be nil when past eof
    if c ~= nil then 
      return i, c
    end
  end

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

    __len = function ()
      return file:seek("end") -- get file size
    end,

    __pairs = function (t)
      return fnext, t, 0  -- function, invariant state, control variable
    end
  }

  return setmetatable(proxy, mt)
end

local f = fileAsArray("editme.txt")
io.write("File size is ", #f, "\n")
--> File size is 53

for _, v in pairs(f) do
  io.write(v)
end
--> We will change this --> A to letter B and then back.

f[25] = "B" -- write B

for _, v in pairs(f) do
  io.write(v)
end
--> We will change this --> B to letter B and then back.

f[25] = "A" -- write back A

for _, v in pairs(f) do
  io.write(v)
end
--> We will change this --> A to letter B and then back.
