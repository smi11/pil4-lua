--[=[

  Exercise 10.2: The patterns '%D' and '[^%d]' are equivalent. What about the
  patterns '[^%d%u]' and '[%D%U]'?

--]=]

print((string.gsub("hello, HELLO, 123!", "%d", ".")))  -- digits
--> hello, HELLO, ...!

print((string.gsub("hello, HELLO, 123!", "[%d]", ".")))  -- digits
--> hello, HELLO, ...!

print((string.gsub("hello, HELLO, 123!", "%D", ".")))  -- not digits
--> ..............123.

print((string.gsub("hello, HELLO, 123!", "[^%d]", ".")))  -- not digits
--> ..............123.

print((string.gsub("hello, HELLO, 123!", "[%d%u]", "."))) -- digits or uppercase letters
--> hello, ....., ...!

print((string.gsub("hello, HELLO, 123!", "[^%d%u]", ".")))  -- not (digits or uppercase letters)
--> .......HELLO..123.

print((string.gsub("hello, HELLO, 123!", "[%D%U]", ".")))  -- not digits or not uppercase letters
--> ..................

-- they are not equivalent:
-- [^%d%u] = not (digits or uppercase letters)
-- [%D%U] = not digits or not uppercase letters
--
-- [%D%U] in essence selects all character classes
