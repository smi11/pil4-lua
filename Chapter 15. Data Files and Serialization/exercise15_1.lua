--[=[

  Exercise 15.1: Modify the code in Figure 15.2, “Serializing tables without
  cycles” so that it indents nested tables. (Hint: add an extra parameter to
  serialize with the indentation string.)

--]=]

-- Figure 15.2. Serializing tables without cycles

function serialize (o, indent, lvl)
  indent = indent or "" -- indentation string
  lvl = lvl or 0        -- depth level
  local t = type(o)
  if t == "number" or t == "string" or t == "boolean" or t == "nil" then
    io.write(string.format("%q", o))
  elseif t == "table" then
    io.write("{\n")
    for k,v in pairs(o) do
      io.write(string.rep(indent,lvl), " ", k, " = ")
      serialize(v, indent, lvl+1)
      io.write(",\n")
    end
    io.write(string.rep(indent,lvl), "}")
  else
    error("cannot serialize a " .. type(o))
  end
end

a = {{"one", "two", {3,4}}, 5, foo = "bar"}

print(serialize(a, "  "))
--> {
-->  1 = {
-->    1 = "one",
-->    2 = "two",
-->    3 = {
-->      1 = 3,
-->      2 = 4,
-->     },
-->   },
-->  2 = 5,
-->  foo = "bar",
--> }
