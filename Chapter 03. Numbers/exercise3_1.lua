--[[

  Exercise 3.1: Which of the following are valid numerals?
  What are their values?

    .0e12 .e12 0.0e 0x12 0xABFG 0xA FFFF 0xFFFFFFFF 0x 0x1P10 0.1e1 0x0.1p1
--]]

print(tonumber(".0e12"))        --> 0.0
print(tonumber(".e12"))         --> nil         (dot cannot stand on its own)
print(tonumber("0.0e"))         --> nil         (no exponent)
print(tonumber("0x12"))         --> 18
print(tonumber("0xABFG"))       --> nil         (G is not a hex character 0..9,A..F)
print(tonumber("0xA"))          --> 10
print(tonumber("FFFF"))         --> nil         (missing 0x at the beginning)
print(tonumber("0xFFFFFFFF"))   --> 4294967295
print(tonumber("0x"))           --> nil         (missing hex number after 0x)
print(tonumber("0x1P10"))       --> 1024.0
print(tonumber("0.1e1"))        --> 1.0
print(tonumber("0x0.1p1"))      --> 0.125
