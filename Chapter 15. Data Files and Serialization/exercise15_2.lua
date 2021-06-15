--[=[

  Exercise 15.2: Modify the code of the previous exercise so that it uses the
  syntax ["key"]=value, as suggested in the section called “Saving tables
  without cycles”.

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
      io.write(string.rep(indent,lvl), " ", string.format("[%q]", k), " = ")
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
-->  [1] = {
-->    [1] = "one",
-->    [2] = "two",
-->    [3] = {
-->      [1] = 3,
-->      [2] = 4,
-->     },
-->   },
-->  [2] = 5,
-->  ["foo"] = "bar",
--> }
