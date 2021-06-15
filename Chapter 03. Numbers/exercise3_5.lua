--[[

  Exercise 3.5: The number 12.7 is equal to the fraction 127/10, where the
  denominator is a power of ten. Can you express it as a common fraction
  where the denominator is a power of two? What about the number 5.5?

  1. Number 12.7 does not have exact finite representation in binary.

  2. We can check if we can find numerator that is an integer when
  multiplied by some power of two. In that case denominator is a power of
  two.

--]]

function find_po2(number)
  -- hack
  -- first use lua's string.format with %a option to get hexadecimal
  -- representation of our number.
  -- if decimal part is full length of 13 decimal places it means it
  -- probably isn't exact finite representation of our decimal number.

  -- we'll cut away leading "0x" and exponent part after and including "p"
  hexfloat = string.gsub( string.format( "%a", number ), "0x(.-)p.*", "%1" )

  local denum = 2
  local i = 1
  local maxfloat = math.tointeger(2^54-1) -- maximum exact integer represented as a float

   -- hexfloat is string "x.y"   1 for #x + 1 for dot + 13 for #y = 15 all together
  if #hexfloat >= 15 then
    maxfloat=0 -- number is most likely not finite binary, so skip search loop
  end

  -- find integer numerator that is power of two of our number
  while number * denum <= maxfloat and math.tointeger(number * denum) == nil do
    i = i + 1
    denum = denum * 2
  end

  if number * denum <= maxfloat then
    return string.format( "%g = %i / %i", number, number*denum, denum )
  else
    return string.format( "%g does not have finite representation in binary", number )
  end
end

print(find_po2(12.7))     --> 12.7 does not have finite representation in binary
print(find_po2(5.5))      --> 5.5 = 11 / 2

-- few extra tests
print(find_po2(3.25))     --> 3.25 = 13 / 4
print(find_po2(7.125))    --> 7.125 = 57 / 8
print(find_po2(13.0625))  --> 13.0625 = 209 / 16
print(find_po2(37.03125)) --> 37.0312 = 1185 / 32
print(find_po2(math.pi))  --> 3.14159 does not have finite representation in binary
print(find_po2(1/2^32))   --> 2.32831e-10 = 1 / 4294967296
print(find_po2(817/16))   --> 51.0625 = 817 / 16
print(find_po2(13/17))    --> 0.764706 does not have finite representation in binary
