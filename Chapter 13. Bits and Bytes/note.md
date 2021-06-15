---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 13. Bits and Bytes
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 13. Bits and Bytes

## Bitwise Operators

* Starting with version 5.3, Lua offers a standard set of bitwise operators on numbers.
* The bitwise operators are `&` (bitwise AND), `|` (bitwise OR), `~` (bitwise exclusive-OR), `>>` (logical right shift), `<<` (left shift), and the unary `~` (bitwise NOT).
* All bitwise operators work on all bits of integers. In Standard Lua, that means 64 bits.

## Unsigned Integers

* The representation of integers uses one bit to store the signal. Therefore, the maximum integer that we can represent with 64-bit integers is 2^63 - 1.
* We can write constants larger than 2^63 - 1 directly, despite appearances:

```
> x = 13835058055282163712      -- 3 << 62
> x --> -4611686018427387904

> string.format("%u", x)        --> 13835058055282163712
> string.format("0x%X", x)      --> 0xC000000000000000

> string.format("%u", x)        --> 13835058055282163712
> string.format("%u", x + 1)    --> 13835058055282163713
> string.format("%u", x - 1)    --> 13835058055282163711

> f = 0xA000000000000000.0                      -- an example
> u = math.tointeger(((f + 2^63) % 2^64) - 2^63)
> string.format("%x", u)                        --> a000000000000000
```

## Packing and Unpacking Binary Data

* Lua 5.3 also introduced functions for converting between binary data and basic values (numbers and strings). The function `string.pack` “packs” values into a binary string; `string.unpack` extracts those values from the string.
* Both `string.pack` and `string.unpack` get as their first argument a format string, which describes how the data is packed. Each letter in this string describes how to pack/unpack one value.

```
> s = string.pack("iii", 3, -27, 450)
> #s --> 12
> string.unpack("iii", s) --> 3 -27 450 13
```

* There are several options for coding an integer, each corresponding to a native integer size: b (char), h (short), i (int), and l (long); the option j uses the size of a Lua integer. To use a fixed, machine-in- dependent size, we can suffix the i option with a number from one to 16. For instance, i7 will produce seven-byte integers. All sizes check for overflows.
* Each integer option has an upper-case version corresponding to an unsigned integer of the same size.
* We can pack strings in three representations: zero-terminated strings, fixed-length strings, and strings with explicit length.
* Zero-terminated strings use the z option.
* For fixed-length strings, we use the option cn, where n is the number of bytes in the packed string.
* The last option for strings stores the string preceded by its length. In that case, the option has the format sn, where n is the size of the unsigned integer used to store the length.
* For floating-point numbers, there are three options: f for single precision, d for double precision, and n for a Lua float.

## Binary files

* In some systems like Windows, we must open binary files in a special way, using the letter b in the mode string of io.open.

```
local inp = assert(io.open(arg[1], "rb"))
local out = assert(io.open(arg[2], "wb"))
local data = inp:read("a")
data = string.gsub(data, "\r\n", "\n")
out:write(data)
assert(out:close())
```

* Also see dump.lua
