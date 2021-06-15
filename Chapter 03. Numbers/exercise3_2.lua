--[[

  Exercise 3.2: Explain the following results:

    > math.maxinteger * 2 --> -2
    > math.mininteger * 2 --> 0
    > math.maxinteger * math.maxinteger --> 1
    > math.mininteger * math.mininteger --> 0

  1) > math.maxinteger * 2 --> -2

     math.maxinteger is 0x7fffffffffffffff in hexadecimal. When we multiply integer
     by 2 we are in fact shifting left by one bit. Least significant bit becomes 0,
     most significant bit becomes 1 which is sign, which means the number overflows
     and become negative. In this case in hex it becomes 0xfffffffffffffffe which
     is -2.

  2) > math.mininteger * 2 --> 0

     math.mininteger is 0x8000000000000000 in hexadecimal. When we multiply integer
     by 2 we are again shifting left by one bit. Least significant bit becomes 0,
     most significant (sign) bit which was 1 is discarded, which means the whole
     number becomes 0 as we lost all bits.

  3) > math.maxinteger * math.maxinteger --> 1

     Let's convert math.maxint to binary but assume we only have 4 bits to make things
     easier to visualize so that math.maxint is 7 in this case. Most significant bit
     is a sign bit used for negative numbers.

     math.maxinteger = 0b0111 --> 4 bits in binary. Top bit is reserved for sign.

     Squaring number 7 we get 49 which needs 6 bits to fully represent in binary:

     49 = 0b110001       --> 6 bits 7*7 in binary

     Since we only have 4 bits to represent our numbers, the top 2 bits are discarded.

     49 = 0b0001         --> lower 4 bits of 7*7 in binary

     That leaves us with number 1. Same applies to 64 bit math.maxinteger and also
     for 32 bit integers if Lua is compiled for that architecture.

  4) > math.mininteger * math.mininteger --> 0

     We'll use same 4 bit sistem. In that case math.mininteger is -8.

     math.mininteger = 0b1000    --> 4 bits in binary. 

     Squaring -8 we get 64.

     64 = 0b1000000   --> we need 7 bits to represent that number.

     Since we only have 4 bits the upper 3 bits are discarded and we are left with:

     64 = 0b0000      --> We are left with only 4 lower bits which is number 0

     Same applies for 64 bit signed integers of Lua. Squaring math.mininteger
     is always 0 since the actual result can't be represented in 64 bits we are
     left with least significant 64 bits of the result which is number 0.

     Same would apply to 32 bit Lua.

--]]

print(math.maxinteger * 2)                --> -2
print(math.mininteger * 2)                --> 0
print(math.maxinteger * math.maxinteger)  --> 1
print(math.mininteger * math.mininteger)  --> 0
