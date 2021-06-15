--[=[

  Exercise 13.1: Write a function to compute the modulo operation for unsigned
  integers.

--]=]

function umod(x, y)
  return ((x >> 1) % y * 2 + (x & 1) - y) % y
end

for i = -7, 7 do
  print(string.format("%u mod %i = %u", i, 5, umod(i, 5)))
end

--> 18446744073709551609 mod 5 = 4
--> 18446744073709551610 mod 5 = 0
--> 18446744073709551611 mod 5 = 1
--> 18446744073709551612 mod 5 = 2
--> 18446744073709551613 mod 5 = 3
--> 18446744073709551614 mod 5 = 4
--> 18446744073709551615 mod 5 = 0
--> 0 mod 5 = 0
--> 1 mod 5 = 1
--> 2 mod 5 = 2
--> 3 mod 5 = 3
--> 4 mod 5 = 4
--> 5 mod 5 = 0
--> 6 mod 5 = 1
--> 7 mod 5 = 2
