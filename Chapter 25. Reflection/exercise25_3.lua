--[=[

  Exercise 25.3: Write a version of getvarvalue (Figure 25.1, “Getting the value
  of a variable”) that returns a table with all variables that are visible at
  the calling function. (The returned table should not include environmental
  variables; instead, it should inherit them from the original environment.)

--]=]

function getallvars(level)
  local t = {}
  local env = nil

  level = (level or 1) + 1

  for i=1,math.huge do
    local n, v = debug.getlocal(level, i)
    if not n then break end
    t[n] = v
  end

  local func = debug.getinfo(level, "f").func
  for i=1,math.huge do
    local n, v = debug.getupvalue(func, i)
    if not n then break end
    if n == "_ENV" then
      env = v
    else
      t[n] = v
    end
  end

  return setmetatable(t,{__index = env})
end

local function test(a,b)
  local c = a+b
  local t = getallvars()  -- t does not exist yet when getallvars is called
  return t
end

a = 10
local b = 11

all1 = getallvars()
all2 = test(1,2)

for name,val in pairs(all1) do
    print(name, val)
end
print("_ENV",getmetatable(all1))
--> b     11
--> test  function: 0x555ee98e9aa0
--> _ENV  table: 0x564ab2a7ca80

print"---"
--> ---

for name,val in pairs(all2) do
    print(name, val)
end
print("_ENV",getmetatable(all2))
--> a     1
--> b     2
--> c     3
--> _ENV  table: 0x564ab2a7c3c0
