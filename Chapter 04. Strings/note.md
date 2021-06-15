---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 4. Strings
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 4. Strings

* Lua is eight-bit clean and its strings can contain bytes with any numeric code, including embedded zeros.
* We can also store Unicode strings in any representation (UTF-8, UTF-16, etc.); however, as we will discuss, there are several good reasons to use UTF-8 whenever possible.
* **Strings in Lua are immutable values.**

```
a = "one string"
b = string.gsub(a, "one", "another")    -- change string parts
print(a)                                --> one string
print(b)                                --> another string

a = "hello"
print(#a)           --> 5
print(#"good bye")  --> 8

> "Hello " .. "World" --> Hello World
> "result is " .. 3   --> result is 3
```

## Literal strings

* We can delimit literal strings by single or double matching quotes.
* Strings in Lua can contain C-like escape sequences.

```
> print("one line\nnext line\n\"in quotes\", 'in quotes'")
one line
next line
"in quotes", 'in quotes'
> print('a backslash inside quotes: \'\\\'')
a backslash inside quotes: '\'
> print("a simpler way: '\\'")
a simpler way: '\'

-- utf8 (Lua 5.3+)
> "\u{3b1} \u{3b2} \u{3b3}" --> # # #
```

## Long strings

* We can delimit literal strings also by matching double square brackets, as we do with long comments.
* We can use mathing number of `=` between square brackets. e.g.: `[=[long [[text]] here]=]`

```
page = [[
<html>
<head>
  <title>An HTML Page</title>
</head>
<body>
  <a href="http://www.lua.org">Lua</a>
</body>
</html>
]]

write(page)

-- escape \z skips newline and indentation of following line (Lua 5.2+)
data = "\x00\x01\x02\x03\x04\x05\x06\x07\z
        \x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"
```

* The `\z` at the end of the first line skips the following end-of-line and the indentation of the second line, so that the byte `\x08` directly follows `\x07` in the resulting string.

## Coercions

* Any arithmetic operation with strings is handled as a floating-point operation.

```
> "10" + 1                --> 11.0  -- not integer!

> tonumber(" -3 ")        --> -3
> tonumber(" 10e4 ")      --> 100000.0
> tonumber("10e")         --> nil (not a valid number)
> tonumber("0x1.3p-4")    --> 0.07421875

> tonumber("100101", 2)   --> 37
> tonumber("fff", 16)     --> 4095
> tonumber("-ZZ", 36)     --> -1295
> tonumber("987", 8)      --> nil

print(tostring(10) == "10") --> true
```

## The String Library

* The string library assumes one-byte characters.

```
> string.rep("abc", 3)            --> abcabcabc
> string.reverse("A Long Line!")  --> !eniL gnoL A
> string.lower("A Long Line!")    --> a long line!
> string.upper("A Long Line!")    --> A LONG LINE!

> s = "[in brackets]"
> string.sub(s, 2, -2)            --> in brackets
> string.sub(s, 1, 1)             --> [
> string.sub(s, -1, -1)           --> ]

print(string.char(97))                    --> a
i = 99; print(string.char(i, i+1, i+2))   --> cde
print(string.byte("abc"))                 --> 97
print(string.byte("abc", 2))              --> 98
print(string.byte("abc", -1))             --> 99
print(string.byte("abc", 1, 2))           --> 97 98

string.format("x = %d y = %d", 10, 20)          --> x = 10 y = 20
string.format("x = %x", 200)                    --> x = c8
string.format("x = 0x%X", 200)                  --> x = 0xC8
string.format("x = %f", 200)                    --> x = 200.000000
tag, title = "h1", "a title"
string.format("<%s>%s</%s>", tag, title, tag)   --> <h1>a title</h1>

print(string.format("pi = %.4f", math.pi))        --> pi = 3.1416
d = 5; m = 11; y = 1990
print(string.format("%02d/%02d/%04d", d, m, y))   --> 05/11/1990

string.find("hello world", "wor")         --> 7 9
string.find("hello world", "war")         --> nil

string.gsub("hello world", "l", ".")      --> he..o wor.d 3
string.gsub("hello world", "ll", "..")    --> he..o world 1
string.gsub("hello world", "a", ".")      --> hello world 0
```

## Unicode

* Since version 5.3, Lua includes a small library to support operations on Unicode strings encoded in UTF-8.

```
> utf8.len("résumé")                        --> 6
> utf8.len("ação")                          --> 4
> utf8.len("Månen")                         --> 5
> utf8.len("ab\x93")                        --> nil 3

> utf8.char(114, 233, 115, 117, 109, 233)   --> résumé
> utf8.codepoint("résumé", 6, 7)            --> 109 233

> s = "Nähdään"
> utf8.codepoint(s, utf8.offset(s, 5))      --> 228
> utf8.char(228) --> ä

> s = "ÃøÆËÐ"
> string.sub(s, utf8.offset(s, -2))         --> ËÐ

for i, c in utf8.codes("Ação") do
  print(i, c)
end
--> 1 65
--> 2 231
--> 4 227
--> 6 111
```
