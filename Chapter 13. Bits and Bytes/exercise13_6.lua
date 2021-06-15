--[=[

  Exercise 13.6: Implement a bit array in Lua. It should support the following
  operations:

  • newBitArray(n) (creates an array with n bits),
  • setBit(a, n, v) (assigns the Boolean value v to bit n of array a),
  • testBit(a, n) (returns a Boolean with the value of bit n).

--]=]

local function newBitArray(n)
  local a = { intsize = #string.pack("j",0) * 8,    -- are integers 32 or 64 bit?
              bits = n }                            -- save size of array in bits
  local ind = n // a.intsize + 1                    -- how many integers do we need?
  for i = 1, ind do a[#a+1] = 0 end                 -- initialize array
  return a
end

local function setBit(a,n,v)
  assert(n <= a.bits,"out of range")
  local ind = n // a.intsize + 1
  local mask = 1 << (( n - 1 ) % a.intsize)         -- our bit array uses counting from 1..n
  if v == true then
    a[ind] = a[ind] | mask                          -- use 'or' to set bit
  else
    a[ind] = a[ind] & ~mask                         -- use 'and' with inverse mask to clear bit
  end
end

local function testBit(a,n)
  assert(n <= a.bits,"out of range")
  local ind = n // a.intsize + 1
  local mask = 1 << (( n - 1 ) % a.intsize)         -- our bit array uses counting from 1..n
  return a[ind] & mask == mask
end

local size = 79
local a = newBitArray(size)

for i = 1,size,5 do -- set every fifth bit
  setBit(a,i,true)
end

for i = 1,size do
  io.write(testBit(a,i) and "1" or "0")
end
print()
--> 1000010000100001000010000100001000010000100001000010000100001000010000100001000

for i = 1,size,10 do -- clear every 10th bit
  setBit(a,i,false)
end

for i = 1,size do
  io.write(testBit(a,i) and "1" or "0")
end
print()
--> 0000010000000001000000000100000000010000000001000000000100000000010000000001000
