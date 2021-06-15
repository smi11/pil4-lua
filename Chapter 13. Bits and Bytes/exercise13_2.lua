--[=[

  Exercise 13.2: Implement different ways to compute the number of bits in the
  representation of a Lua integer.

--]=]

local function bits1()
  local i, n = 0, -1
  while n ~= 0 do     -- test how many bits we have to shift to get 0
    i = i + 1
    n = n << 1
  end
  return i
end

local function bits2()
  return #string.format("%x",-1) * 4  -- each hex number is 4 bits
end

local function bits3()
  return #string.pack("j",0) * 8   -- j = native Lua integer type, number of bytes * 8 bits
end

print(bits1())
--> 64

print(bits2())
--> 64

print(bits3())
--> 64
