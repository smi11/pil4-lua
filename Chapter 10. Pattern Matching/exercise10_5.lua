--[=[

  Exercise 10.5: Write a function to format a binary string as a literal in Lua,
  using the escape sequence \x for all bytes:

  print(escape("\0\1hello\200"))
  --> \x00\x01\x68\x65\x6C\x6C\x6F\xC8

  As an improved version, use also the escape sequence \z to break long lines.

--]=]

local function escape(s)
  return (s:gsub(".", function(c)
                        return string.format("\\x%02x", string.byte(c))
                      end))
end

local function escape2(s, width)
  width = width or 10 -- default number of escape sequences per line excluding \z
  return (s:gsub("()(.)", function(pos,c)
                            local linebrk = pos % width == 0 and pos < #s and "\\z\n" or ""
                            return string.format("\\x%02x", string.byte(c)) .. linebrk
                          end))
end

print(escape("\0\1hello\200"))
--> \x00\x01\x68\x65\x6C\x6C\x6F\xC8

print(escape("some other string\nin two lines"))
--> \x73\x6f\x6d\x65\x20\x6f\x74\x68\x65\x72\x20\x73\x74\x72\x69\x6e\x67\x0a\x69\x6e\x20\x74\x77\x6f\x20\x6c\x69\x6e\x65\x73

print(escape2("\0\1hello\200"))
--> \x00\x01\x68\x65\x6C\x6C\x6F\xC8

print(escape2("some other string\nin two lines"))
--> \x73\x6f\x6d\x65\x20\x6f\x74\x68\x65\x72\z
--> \x20\x73\x74\x72\x69\x6e\x67\x0a\x69\x6e\z
--> \x20\x74\x77\x6f\x20\x6c\x69\x6e\x65\x73

print(escape2("some other string\nin two lines",5))
--> \x73\x6f\x6d\x65\x20\z
--> \x6f\x74\x68\x65\x72\z
--> \x20\x73\x74\x72\x69\z
--> \x6e\x67\x0a\x69\x6e\z
--> \x20\x74\x77\x6f\x20\z
--> \x6c\x69\x6e\x65\x73

print(escape2("some other string\nin two lines",4))
--> \x73\x6f\x6d\x65\z
--> \x20\x6f\x74\x68\z
--> \x65\x72\x20\x73\z
--> \x74\x72\x69\x6e\z
--> \x67\x0a\x69\x6e\z
--> \x20\x74\x77\x6f\z
--> \x20\x6c\x69\x6e\z
--> \x65\x73
