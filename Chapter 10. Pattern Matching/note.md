---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 10. Pattern Matching
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 10. Pattern Matching

## The Pattern-Matching Functions

### The function `string.find`

```
s = "hello world"
i, j = string.find(s, "hello")
print(i, j) --> 1 5
print(string.sub(s, i, j)) --> hello
print(string.find(s, "world")) --> 7 11
i, j = string.find(s, "l")
print(i, j) --> 3 3
print(string.find(s, "lll")) --> nil

> string.find("a [word]", "[")
stdin:1: malformed pattern (missing ']')
> string.find("a [word]", "[", 1, true) --> 3 3
```

### The function `string.match`

* The function `string.match` is similar to find, in the sense that it also searches for a pattern in a string. However, instead of returning the positions where it found the pattern, it returns the part of the subject string that matched the pattern.

```
print(string.match("hello world", "hello")) --> hello

date = "Today is 17/7/1990"
d = string.match(date, "%d+/%d+/%d+")
print(d) --> 17/7/1990
```

### The function `string.gsub`

* The function `string.gsub` has three mandatory parameters: a subject string, a pattern, and a replacement string.
* Its basic use is to substitute the replacement string for all occurrences of the pattern inside the subject string:

```
s = string.gsub("Lua is cute", "cute", "great")
print(s)                                            --> Lua is great
s = string.gsub("all lii", "l", "x")
print(s)                                            --> axx xii
s = string.gsub("Lua is great", "Sol", "Sun")
print(s)                                            --> Lua is great
```

* An optional fourth parameter limits the number of substitutions to be made.

```
s = string.gsub("all lii", "l", "x", 1) print(s) --> axl lii
s = string.gsub("all lii", "l", "x", 2) print(s) --> axx lii
```

### The function `string.gmatch`

* The function string.gmatch returns a function that iterates over all occurrences of a pattern in a string.

```
s = "some string"
words = {}
for w in string.gmatch(s, "%a+") do
  words[#words + 1] = w
end
```

## Patterns

* Patterns in Lua use the percent sign as an escape.
* A character class is an item in a pattern that can match any character in a specific set.

| class |             set              |              meaning               |
|-------|------------------------------|------------------------------------|
| .     | [\0-\255]                    | all characters                     |
| %a    | [a-zA-Z]                     | letters                            |
| %c    | [\0-\31]                     | control characters                 |
| %d    | [0-9]                        | digits                             |
| %g    | [\33-\126]                   | printable characters except spaces |
| %l    | [a-z]                        | lower-case letters                 |
| %p    | [!"#$%&'()*+,-./[\%]^_`{|}~] | punctuation characters             |
| %s    | [ \t\n\v\f\r]                | space characters                   |
| %u    | [A-Z]                        | upper-case letters                 |
| %w    | [a-zA-Z0-9]                  | alphanumeric characters            |
| %x    | [0-9a-fA-F]                  | hexadecimal digits                 |

* An upper-case version of any of these classes represents the complement of the class.
* Some characters, called magic characters, have special meanings when used in a pattern. Patterns in Lua use the following magic characters: `( ) . % + - * ? [ ] ^ $`
* So, '%?' matches a question mark and '%%' matches a percent sign itself. We can escape not only the magic characters, but also any non-alphanumeric character. When in doubt, play safe and use an escape.
* A char-set allows us to create our own character classes, grouping single characters and classes inside square brackets. For instance, the char-set `[%w_]` matches both alphanumeric characters and underscores, `[01]` matches binary digits, and `[%[%]]` matches square brackets.
* We can also include character ranges in a char-set, by writing the first and the last characters of the range separated by a hyphen.
* We can get the complement of any char-set by starting it with a caret: the pattern '[^0-7]' finds any character that is not an octal digit and '[^\n]' matches any character different from newline.

| modifier |           meaning            |
|----------|------------------------------|
| +        | 1 or more repetitions        |
| *        | 0 or more repetitions        |
| -        | 0 or more lazy repetitions   |
| ?        | optional (0 or 1 occurrence) |

* In Lua we can apply a modifier only to a character class.
* If a pattern begins with a caret, it will match only at the beginning of the subject string.
* Similarly, if it ends with a dollar sign, it will match only at the end of the subject string.
* Another item in a pattern is `%b`, which matches balanced strings. We write this item as `%bxy`, where x and y are any two distinct characters; the x acts as an opening character and the y as the closing one.
* For instance, the pattern `%b()` matches parts of the string that start with a left parenthesis and finish at the respective right one.
* Finally, the item `%f[char-set]` represents a frontier pattern. It matches an empty string only if the next character is in char-set but the previous one is not.

## Captures

* The capture mechanism allows a pattern to yank parts of the subject string that match parts of the pattern for further use.
* We specify a capture by writing the parts of the pattern that we want to capture between parentheses.

```
pair = "name = Anna"
key, value = string.match(pair, "(%a+)%s*=%s*(%a+)")
print(key, value)                                       --> name Anna
```

* In a pattern, an item like `%n`, where n is a single digit, matches only a copy of the n-th capture.

```
s = [[then he said: "it's all right"!]]
q, quotedPart = string.match(s, "([\"'])(.-)%1")
print(quotedPart)                                   --> it's all right
print(q)                                            --> "
```

* Match long string: `%[(=*)%[(.-)%]%1%]`

```
print((string.gsub("hello Lua!", "%a", "%0-%0"))) --> h-he-el-ll-lo-o L-Lu-ua-a! print((string.gsub("hello Lua", "(.)(.)", "%2%1"))) --> ehll ouLa

s = [[the \quote{task} is to \em{change} that.]]
s = string.gsub(s, "\\(%a+){(.-)}", "<%1>%2</%1>")
print(s) --> the <quote>task</quote> is to <em>change</em> that.

function trim (s)
  s = string.gsub(s, "^%s*(.-)%s*$", "%1")
  return s
end
```

## Replacements

* When invoked with a function, `string.gsub` calls the function every time it finds a match; the arguments to each call are the captures, and the value that the function returns becomes the replacement string.
* When invoked with a table, `string.gsub` looks up the table using the first capture as the key, and the associated value is used as the replacement string. If the result from the call or from the table lookup is nil, gsub does not change the match.

```
function expand (s)
  return (string.gsub(s, "$(%w+)", _G))
end
name = "Lua"; status = "great"
print(expand("$name is $status, isn't it?")) --> Lua is great, isn't it?

function expand (s)
  return (string.gsub(s, "$(%w+)", function (n)
    return tostring(_G[n]) 
  end))
end
print(expand("print = $print; a = $a")) --> print = function: 0x8050ce0; a = nil

function toxml (s)
  s = string.gsub(s, "\\(%a+)(%b{})", function (tag, body)
        body = string.sub(body, 2, -2)  -- remove the brackets
        body = toxml(body)              -- handle nested commands
        return string.format("<%s>%s</%s>", tag, body, tag)
      end)
  return s
end
print(toxml("\\title{The \\bold{big} example}"))
  --> <title>The <bold>big</bold> example</title>
```

## URL encoding

```
function unescape (s)
  s = string.gsub(s, "+", " ")
  s = string.gsub(s, "%%(%x%x)", function (h)
        return string.char(tonumber(h, 16))
      end)
  return s
end
print(unescape("a%2Bb+%3D+c")) --> a+b = c

cgi = {}
function decode (s)
  for name, value in string.gmatch(s, "([^&=]+)=([^&=]+)") do
    name = unescape(name)
    value = unescape(value)
    cgi[name] = value
  end
end

function escape (s)
  s = string.gsub(s, "[&=+%%%c]", function (c)
        return string.format("%%%02X", string.byte(c))
      end)
  s = string.gsub(s, " ", "+")
  return s
end

function encode (t)
  local b = {}
  for k,v in pairs(t) do
    b[#b + 1] = (escape(k) .. "=" .. escape(v))
  end
  -- concatenates all entries in 'b', separated by "&"
  return table.concat(b, "&")
end
t = {name = "al", query = "a+b = c", q = "yes or no"}
print(encode(t)) --> q=yes+or+no&query=a%2Bb+%3D+c&name=al
```

## Tab expansion

* An empty capture like `()` captures its position in the subject string, as a number: `print(string.match("hello", "()ll()")) --> 3 5`

```
function expandTabs (s, tab)
  tab = tab or 8 -- tab "size" (default is 8)
  local corr = 0 -- correction
  s = string.gsub(s, "()\t", function (p)
        local sp = tab - (p - 1 + corr)%tab
        corr = corr - 1 + sp
        return string.rep(" ", sp)
      end)
  return s
end

function unexpandTabs (s, tab)
  tab = tab or 8
  s = expandTabs(s, tab)
  local pat = string.rep(".", tab)
  s = string.gsub(s, pat, "%0\1")
  s = string.gsub(s, " +\1", "\t")
  s = string.gsub(s, "\1", "")
  return s
end
```

## Tricks of the Trade

* Pattern matching is not a replacement for a proper parser.

```
test = [[char s[] = "a /* here"; /* a tricky string */]]
print((string.gsub(test, "/%*.-%*/", "<COMMENT>"))) --> char s[] = "a <COMMENT>
```

* Beware also of empty patterns, that is, patterns that match the empty string. For instance, if we try to match names with a pattern like '%a*', we will find names everywhere:

```
i, j = string.find(";$% **#$hello13", "%a*")
print(i,j) --> 1 0
```

* In this example, the call to string.find has correctly found an empty sequence of letters at the beginning of the string.
* It never makes sense to write a pattern that ends with the minus modifier, because it will match only the empty string. This modifier always needs something after it to anchor its expansion.
* Similarly, patterns that include `.*` are tricky, because this construction can expand much more than we intended.
* Sometimes, it is useful to use Lua itself to build a pattern: `pattern = string.rep("[^\n]", 70) .. "+"`

```
function nocase (s)
  s = string.gsub(s, "%a", function (c)
        return "[" .. string.lower(c) .. string.upper(c) .. "]"
      end)
  return s
end
print(nocase("Hi there!")) --> [hH][iI] [tT][hH][eE][rR][eE]!
```

```
function code (s)
  return (string.gsub(s, "\\(.)", function (x)
            return string.format("\\%03d", string.byte(x))
          end))
end

function decode (s)
  return (string.gsub(s, "\\(%d%d%d)", function (d)
            return "\\" .. string.char(tonumber(d))
          end))
end

s = [[follows a typical string: "This is \"great\"!".]]
s = code(s)
s = string.gsub(s, '".-"', string.upper)
s = decode(s)
print(s) --> follows a typical string: "THIS IS \"GREAT\"!".

-- or
print(decode(string.gsub(code(s), '".-"', string.upper)))
```
