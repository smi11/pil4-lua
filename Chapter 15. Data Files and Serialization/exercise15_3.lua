--[=[

  Exercise 15.3: Modify the code of the previous exercise so that it uses the
  syntax ["key"]=value only when necessary (that is, when the key is a string
  but not a valid identifier).

--]=]

local serialize, serializekey
do
  function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
  end

  local reserved = Set{ "and", "break", "do", "else", "elseif", "end", "false", "for",
                        "function", "goto", "if", "in", "local", "nil", "not", "or",
                        "repeat", "return", "then", "true", "until", "while" }
  
  function serializekey(k)
    if type(k) == "string" and k == string.match(k,"^[%a_][%w_]*$") and not reserved[k] then
      return k
    end
    return string.format("[%q]", k)
  end
end

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
      if type(k) ~= "table" then
        io.write(string.rep(indent,lvl), " ", serializekey(k), " = ")
      else
        io.write(" ")
        serialize(k, indent, lvl+1)
        io.write(" = ")
      end
      serialize(v, indent, lvl+1)
      io.write(",\n")
    end
    io.write(string.rep(indent,lvl), "}")
  else
    error("cannot serialize a " .. type(o))
  end
end

a = {{"one", "two", {3,4}}, 5, foo = "bar", ["while"]=123, ["not valid identifier"] = "abc", [111] = 111}

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
-->  foo = "bar",
-->  ["while"] = 123,
-->  [111] = 111,
-->  ["not valid identifier"] = "abc",
--> }
