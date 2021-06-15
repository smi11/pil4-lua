--[=[

  Exercise 5.2: Assume the following code:

  a = {}; a.a = a

  What would be the value of a.a.a.a? Is any a in that sequence somehow
  different from the others?

  Now, add the next line to the previous code:

  a.a.a.a = 3

  What would be the value of a.a.a.a now?

--]=]

a = {}; a.a = a  -- a.a now points to the table a

print(a, a.a, a.a.a, a.a.a.a, a.a.a.a.a )
--> table: 0x80004f810  table: 0x80004f810  table: 0x80004f810  table: 0x80004f810  table: 0x80004f810

-- What would be the value of a.a.a.a?
-- The value of a.a.a.a is a reference to table 'a'.

-- Is any a in that sequence somehow different from the others?
-- No. Every key 'a' in that sequence points to same table 'a'. In fact it
-- is the same key 'a'.

a.a.a.a = 3

-- What would be the value of a.a.a.a now?
-- Now the key 'a' no longer points to table 'a' but contains number 3.
-- That makes the sequence invalid as key 'a' is no longer reference to table 'a'.
-- Only a.a is valid and contains number 3.

print(a.a)   --> 3
print(a.a.a) --> Error: lua: exercise5_2.lua:33: attempt to index a number value (field 'a')
