--[=[

  Exercise 13.5: Write a function to test whether the binary representation of a
  given integer is a palindrome.

--]=]

local function ispalindrome(n, bits)
  bits = bits or #string.pack("j",0) * 8 -- if not specified assume integer size (32/64)
  local rev = 0 -- here we'll build reverse bits from n
  local m = n   -- copy of n, so we do not destroy original
  for i = 1, bits do       -- create rev with reversed bits from n
    rev = rev << 1
    rev = rev | ( m & 1 ) -- merge lowest bit from m to rev
    m = m >> 1
  end
  return rev == n
end

-- convert number to binary
function tobits(num,bits)
  bits = bits or math.max(1, select(2, math.frexp(num)))
  local t = {}
  for b = bits, 1, -1 do
    t[b] = math.fmod(num, 2)
    num = math.floor((num - t[b]) / 2)
  end
  return table.concat(t)
end

-- print all palindromes from 8 bits
for i = 0, 255 do
  if ispalindrome(i,8) then
    print(i, tobits(i,8))
  end
end

--> 0       00000000
--> 24      00011000
--> 36      00100100
--> 60      00111100
--> 66      01000010
--> 90      01011010
--> 102     01100110
--> 126     01111110
--> 129     10000001
--> 153     10011001
--> 165     10100101
--> 189     10111101
--> 195     11000011
--> 219     11011011
--> 231     11100111
--> 255     11111111
