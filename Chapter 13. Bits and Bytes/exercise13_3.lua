--[=[

  Exercise 13.3: How can you test whether a given integer is a power of two?

--]=]

local function ispowerof2(num)
  return num & ( num - 1 ) == 0 -- we do bitwise 'and' between num and num - 1
                                -- if none of the bits are on then num is power of 2
end

-- test all numbers from 0 to 65536
for i = 0, 1 << 16 do
  if ispowerof2(i) then print(i) end
end

--> 0
--> 1
--> 2
--> 4
--> 8
--> 16
--> 32
--> 64
--> 128
--> 256
--> 512
--> 1024
--> 2048
--> 4096
--> 8192
--> 16384
--> 32768
--> 65536
