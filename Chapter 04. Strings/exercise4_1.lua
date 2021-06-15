--[=[

  Exercise 4.1: How can you embed the following fragment of XML as a string
  in a Lua program?

  <![CDATA[
    Hello world
  ]]>

  Show at least two different ways.

--]=]

-- this string ends with linebreak character because ]=] marker is in new line
local myXMLdata1 = [=[
<![CDATA[
  Hello world
]]>
]=]

-- this string doesn't, but it is trivial to add it
-- I just wanted to emphasize minor difference betwen ordinary and long string
local myXMLdata2 = "<![CDATA[\n  Hello world\n]]>"

-- the final linebreak can be seen as a blank line between both strings
print(myXMLdata1)
print(myXMLdata2)

-- I prefer long strings for this as they are much easier to read
