--[=[

  Exercise 15.5: The approach of avoiding constructors when saving tables with
  cycles is too radical. It is possible to save the table in a more pleasant
  format using constructors for the simple case, and to use assignments later
  only to fix sharing and loops. Reimplement the function save (Figure 15.3,
  “Saving tables with cycles”) using this approach. Add to it all the goodies
  that you have implemented in the previous exercises (indentation, record
  syntax, and list syntax).

--]=]

-- a bit ugly solution, maybe I'll clean it up someday

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
  
  function serializekey(k, prepend)
    prepend = prepend or ""
    if type(k) == "string" and k == string.match(k,"^[%a_][%w_]*$") and not reserved[k] then
      return prepend..k
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

local function dump(name, value, indent, lvl, saved)
  saved = saved or {}     -- here we'll save cycles and visited tables
  indent = indent or "  " -- indentation string
  lvl = lvl or 0          -- depth level

  -- Figure 15.2. Serializing tables without cycles
  
  local function serialize (name, o, indent, lvl)
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
      io.write(string.format("%q", o))
    elseif t == "table" and saved[name] then
      return -- skip tables that are cycles
    elseif islist(o) then
      io.write("{ ")
      -- do table that is pure list in single line 
      for i, v in ipairs(o) do
        local fname = name..serializekey(i,".")
        if saved[fname] then
          io.write(", true") -- placeholder for cycle item
        else
          if i > 1 then io.write(", ") end -- skip comma for first item
          serialize(fname, v, indent, lvl+1)
        end
      end
      io.write(" }")
    elseif t == "table" then
      io.write("{\n")
      -- first do list part of table, if there is one
      for i, v in ipairs(o) do
        local fname = name..serializekey(i,".")
        if saved[fname] then
          io.write(",\n true") -- placeholder for cycle item
        else
          if i > 1 then io.write(",\n") end -- last element will not have comma
          io.write(" ")
          serialize(fname, v, indent, lvl+1)
        end
      end
      local first = #o < 1
      -- do the rest of k,v pairs
      for k,v in pairs(o) do
        local fname = name..serializekey(k,".")
        if saved[fname] then goto skip end
        local tk = type(k)
        -- make sure we don't repeat the list part
        if ( tk == "number" and ( k > #o or k < 1) ) or tk ~= "number" then
          if not first then io.write(",\n") end
          first = false
          if type(k) ~= "table" then
            io.write(string.rep(indent,lvl), " ", serializekey(k), " = ")
          else
            io.write(" ")
            serialize(fname, k, indent, lvl+1)
            io.write(" = ")
          end
          serialize(fname, v, indent, lvl+1)
        end
        ::skip::
      end
      io.write("\n",string.rep(indent,lvl),"}")
    else
      error("cannot serialize a " .. type(o))
    end
  end
  
  -- Figure 15.3. Saving tables with cycles
  
  function scancycles (name, value)
    if type(value) == "table" then
      if saved[value] then -- value already saved?
        saved[name] = saved[value] -- it's a cycle, so save the reference to it
      else
        saved[value] = name -- save name for next time
        for k,v in pairs(value) do -- save its fields
          local fname = name..serializekey(k,".")
          scancycles(fname, v)
        end
      end
    end
  end

  scancycles(name,value)            -- scan entire table tree and save cycles
  io.write(name," = ")
  serialize(name,value,indent,lvl)  -- serialize record structure excluding cycles
  io.write("\n")
  for k,v in pairs(saved) do        -- list cycles
    if type(k) == "string" then
      io.write(k," = ",v,"\n")
    end
  end
end

b = { "hello"}
a = { {"one", "two", b, {3,4} },
      5,
      foo = "bar",
      flag = true,
      baz={1,2,3},
      ["while"]=123,
      ["not valid identifier"] = "abc",
      [111] = b,
      [112] = "hello",
      deep={deeper={evendeeper=0,list={"a","b","c"}}}}
a[3] = a
a[4] = a
a[1][5] = a[1]

t = {}
dump("b",b,"  ",0,t)
dump("a",a,"  ",0,t)
--> b = { "hello" }
--> a = {
-->  { "one", "two", true, { 3, 4 }, true },
-->  5,
-->  true,
-->  true,
-->  flag = true,
-->  ["not valid identifier"] = "abc",
-->  foo = "bar",
-->  deep = {
-->    deeper = {
-->      list = { "a", "b", "c" },
-->      evendeeper = 0
-->     }
-->   },
-->  [112] = "hello",
-->  ["while"] = 123,
-->  baz = { 1, 2, 3 }
--> }
--> a[1][3] = b
--> a[4] = a
--> a[1][5] = a[1]
--> a[3] = a
--> a[111] = b
