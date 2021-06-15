--[=[

  Exercise 13.4: Write a function to compute the Hamming weight of a given
  integer. (The Hamming weight of a number is the number of ones in its binary
  representation.)

--]=]

local function hamming(n, bits)
  local bits = bits or 64 -- integers in standard Lua are 64 bits
  local result = 0
  for i = 1, bits do
    result = result + (n & 1) -- add lowest bit
    n = n >> 1                -- shift n to the right to test next bit
  end
  return result
end

for i = 0, 15 do
  print(i, hamming(i))
end

--> 0       0
--> 1       1
--> 2       1
--> 3       2
--> 4       1
--> 5       2
--> 6       2
--> 7       3
--> 8       1
--> 9       2
--> 10      2
--> 11      3
--> 12      2
--> 13      3
--> 14      3
--> 15      4
