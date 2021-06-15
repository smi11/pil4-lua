--[=[

  Exercise 15.4: Modify the code of the previous exercise so that it uses the
  constructor syntax for lists whenever possible. For instance, it should
  serialize the table {14, 15, 19} as {14, 15, 19}, not as {[1] = 14, [2] = 15,
  [3] = 19}. (Hint: start by saving the values of the keys 1, 2, ..., as long as
  they are not nil. Take care not to save them again when traversing the rest of
  the table.)

--]=]

local serializekey
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

local function islist(t)
  if type(t) ~= "table" then
    return false
  end
  local count = 0
  for k, v in pairs(t) do
    count = count + 1
  end
  return count == #t
end

-- Figure 15.2. Serializing tables without cycles

local function serialize (o, indent, lvl)
  indent = indent or "  " -- indentation string
  lvl = lvl or 0          -- depth level
  local t = type(o)
  if t == "number" or t == "string" or t == "boolean" or t == "nil" then
    io.write(string.format("%q", o))
  elseif islist(o) then
    io.write("{ ")
    -- do table that is pure list in single line 
    for i, v in ipairs(o) do
      if i > 1 then io.write(", ") end -- skip comma for first item
      serialize(v, indent, lvl+1)
    end
    io.write(" }")
  elseif t == "table" then
    io.write("{\n")
    -- first do list part of table, if there is one
    for i, v in ipairs(o) do
      if i > 1 then io.write(",\n") end -- last element will not have comma
      io.write(" ")
      serialize(v, indent, lvl+1)
    end
    local first = #o < 1
    -- do the rest of k,v pairs
    for k,v in pairs(o) do
      local tk = type(k)
      -- make sure we don't repeat the list part
      if ( tk == "number" and ( k > #o or k < 1) ) or tk ~= "number" then
        if not first then io.write(",\n") end
        first = false
        if type(k) ~= "table" then
          io.write(string.rep(indent,lvl), " ", serializekey(k), " = ")
        else
          io.write(" ")
          serialize(k, indent, lvl+1)
          io.write(" = ")
        end
        serialize(v, indent, lvl+1)
      end
    end
    io.write("\n",string.rep(indent,lvl),"}")
  else
    error("cannot serialize a " .. type(o))
  end
end

a = { {"one", "two", {3,4}},
      5,
      foo = "bar",
      baz={1,2,3},
      ["while"]=123,
      ["not valid identifier"] = "abc",
      [111] = 111,
      deep={deeper={evendeeper=0,list={"a","b","c"}}}}

print(serialize(a))
--> {
-->  { "one", "two", { 3, 4 } },
-->  5,
-->  foo = "bar",
-->  baz = { 1, 2, 3 },
-->  deep = {
-->    deeper = {
-->      evendeeper = 0,
-->      list = { "a", "b", "c" }
-->     }
-->   },
-->  ["while"] = 123,
-->  [111] = 111,
-->  ["not valid identifier"] = "abc"
--> }
