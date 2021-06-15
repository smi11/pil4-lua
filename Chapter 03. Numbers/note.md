---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 3. Numbers
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 3. Numbers

* Until version 5.2, Lua represented all numbers using double-precision floating-point format.
* Starting with version 5.3, Lua uses two alternative representations for numbers: 64-bit integer numbers, called simply integers, and double-precision floating-point numbers, called simply floats.

## Numerals

```
> type(3)           --> number
> type(3.5)         --> number
> type(3.0)         --> number

> 1 == 1.0          --> true
> -3 == -3.0        --> true
> 0.2e3 == 200      --> true

> math.type(3)      --> integer
> math.type(3.0)    --> float
```

*  Lua supports hexadecimal constants, by prefixing them with `0x`.

```
> 0xff                      --> 255     (Hexadecimal integers and floats)
> 0x1A3                     --> 419
> 0x0.2                     --> 0.125
> 0x1p-1                    --> 0.5     (Lua 5.2+)
> 0xa.bp2                   --> 42.75

> string.format("%a", 419)  --> 0x1.a3p+8
> string.format("%a", 0.1)  --> 0x1.999999999999ap-4
```

## Arithmetic Operators

```
> 13 + 15       --> 28    (operations with integers produce integer)
> 13.0 + 15.0   --> 28.0

> 13.0 + 25     --> 38.0  (operation between integer and float produce float)
> -(3 * 6.0)    --> -18.0

> 3.0 / 2.0     --> 1.5   (division always produce float)
> 3 / 2         --> 1.5

> 3 // 2        --> 1     (integer floor division, Lua 5.3+)
> 3.0 // 2      --> 1.0
> 6 // 2        --> 3
> 6.0 // 2.0    --> 3.0
> -9 // 2       --> -5
> 1.5 // 0.5    --> 3.0

-- modulo operator
a % b == a - ((a // b) * b)

> x = math.pi
> x - x%0.01    --> 3.14
> x - x%0.001   --> 3.141
```

## Relational Operators

* Lua provides the following relational operators: `< > <= >= == ~=`

## The Mathematical Library

* Lua provides a standard `math` library with a set of mathematical functions, including trigonometric functions (`sin`, `cos`, `tan`, `asin`, etc.), logarithms, rounding functions, `max` and `min`, a function for generating pseudo-random numbers (`random`), plus the constants `pi` and `huge` (inf on most platforms.)

```
> math.sin(math.pi / 2)       --> 1.0
> math.max(10.4, 7, -3, 20)   --> 20
> math.huge                   --> inf
```

## Random-number generator

```
> math.random()               --> 0.1234254  [0,1)
> math.random(6)              --> 2          n=6; [1,n]
> math.random(10,20)          --> 17         l=10, u=20; [l,u]
> math.randomseed(os.time())  -- sets random seed
```

## Rounding functions

```
> math.floor(3.3)   --> 3     (Rounding functions)
> math.floor(-3.3)  --> -4
> math.ceil(3.3)    --> 4
> math.ceil(-3.3)   --> -3
> math.modf(3.3)    --> 3     0.3
> math.modf(-3.3)   --> -3    -0.3
> math.floor(2^70)  --> 1.1805916207174e+21
```

## Representation Limits

* lua has 64 bit integers unless compiled for 32 bit

```
> math.maxinteger     --> 9223372036854775807
> 0x7fffffffffffffff  --> 9223372036854775807
> math.mininteger     --> -9223372036854775808
> 0x8000000000000000  --> -9223372036854775808 

> math.maxinteger + 1 == math.mininteger    --> true
> math.mininteger - 1 == math.maxinteger    --> true
> -math.mininteger == math.mininteger       --> true
> math.mininteger // -1 == math.mininteger  --> true

-- wrong computations
> math.maxinteger + 2   --> -9223372036854775807   (integer overflow)
> math.maxinteger + 2.0 --> 9.2233720368548e+18    (approximate value for floats)

> math.maxinteger + 2.0 == math.maxinteger + 1.0 --> true (approximate floats)
```

## Conversions

```
> -3 + 0.0                  --> -3.0                (conversion to float)
> 0x7fffffffffffffff + 0.0  --> 9.2233720368548e+18

-- floats can accurately represent integers up to 2^53 (which is 9007199254740992)
> 9007199254740991 + 0.0 == 9007199254740991 --> true
> 9007199254740992 + 0.0 == 9007199254740992 --> true
> 9007199254740993 + 0.0 == 9007199254740993 --> false

> 2^53      --> 9.007199254741e+15  (float)
> 2^53 | 0  --> 9007199254740992    (integer, OR with 0 Lua 5.3+)

> math.tointeger(-258.0)  --> -258
> math.tointeger(2^30)    --> 1073741824
> math.tointeger(5.01)    --> nil         (not an integral value)
> math.tointeger(2^64)    --> nil         (out of range)

function cond2int (x)            -- convert to int if possible or leave it as it is
  return math.tointeger(x) or x
end
```

## Precedence

```
^
unary operators   (- # ~ not)
* / // %
+ -
..                (concatentation)
<< >>             (bitwise shifts)
&                 (bitwise AND)
~                 (bitwise exclusive OR)
|                 (bitwise OR)
< > <= >= ~= ==
and
or
```

* All binary operators are left associative, except for exponentiation and concatenation, which are right associative.

## Lua Before Integers

* The main incompatibility between Lua 5.3 and Lua 5.2 is the representation limits for integers.
* Lua 5.2 can represent exact integers only up to 2^53 , while in Lua 5.3 the limit is 2^63.
* Lua 5.2 does not offer the function `math.type`, as all numbers have the same subtype. Lua 5.2 does not offer the constants `math.maxinteger` and `math.mininteger`, as it has no integers. Lua 5.2 also does not offer floor division, although it could.
* The main source of problems related to the introduction of integers was how Lua converts numbers to strings.
* Lua 5.2 formats 3.0 as "3", while Lua 5.3 formats it as "3.0".
