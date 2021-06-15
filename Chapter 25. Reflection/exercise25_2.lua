--[=[

  Exercise 25.2: Write a function setvarvalue similar to getvarvalue (Figure
  25.1, “Getting the value of a variable”).

--]=]

function getvarvalue (name, level, isenv)
  local value
  local found = false

  level = (level or 1) + 1

  -- try local variables
  for i = 1, math.huge do
    local n, v = debug.getlocal(level, i)
    if not n then break end
    if n == name then
      value = v
      found = true
    end
  end
  if found then return "local", value end

  -- try non-local variables
  local func = debug.getinfo(level, "f").func
  for i = 1, math.huge do
    local n, v = debug.getupvalue(func, i)
    if not n then break end
    if n == name then return "upvalue", v end
  end

  if isenv then return "noenv" end -- avoid loop

  -- not found; get value from the environment
  local _, env = getvarvalue("_ENV", level, true)
  if env then
    return "global", env[name]
  else -- no _ENV available
    return "noenv"
  end
end

function setvarvalue (name, value, level)
  local found = false

  level = (level or 1) + 1

  -- try local variables
  for i = 1, math.huge do
    local n, v = debug.getlocal(level, i)
    if not n then break end
    if n == name then
      return debug.setlocal(level, i, value)
    end
  end

  -- try non-local variables
  local func = debug.getinfo(level, "f").func
  for i = 1, math.huge do
    local n, v = debug.getupvalue(func, i)
    if not n then break end
    if n == name then return debug.setupvalue(func, i, value) end
  end

  -- not found; get value from the environment
  local _, env = getvarvalue("_ENV", level, true)
  if env then
    env[name] = value
    return name
  else -- no _ENV available
    return "noenv"
  end
end

a = "xx"
print(setvarvalue("a","xxx"), getvarvalue("a"), a)
--> a global  xxx

local a = 4
print(setvarvalue("a", 5), getvarvalue("a"), a)
--> a local 5

local function up(x)
  return function()
    return setvarvalue("x",x+1), getvarvalue("x")
  end
end

a = up(11)
print(a())
--> x upvalue 12
