--[=[

  Exercise 25.1: Adapt getvarvalue (Figure 25.1, “Getting the value of a
  variable”) to work with different coroutines (like the functions from the
  debug library).

--]=]

-- Figure 25.1. Getting the value of a variable

function getvarvalue (thread, name, level, isenv)
  if type(thread) ~= "thread" then
    name, level, isenv, thread = thread, name, level, coroutine.running()
  end
  local main = thread == coroutine.running()

  local value
  local found = false

  level = (level or 1) + ( main and 1 or 0 ) -- adjust stack index for threads

  -- try local variables
  for i = 1, math.huge do
    local n, v = debug.getlocal(thread, level, i)
    if not n then break end
    if n == name then
      value = v
      found = true
    end
  end
  if found then return "local", value end

  -- try non-local variables
  local func = debug.getinfo(thread, level, "f").func
  for i = 1, math.huge do
    local n, v = debug.getupvalue(func, i)
    if not n then break end
    if n == name then return "upvalue", v end
  end

  if isenv then return "noenv" end -- avoid loop

  -- not found; get value from the environment
  local _, env = getvarvalue(thread, "_ENV", level, true)
  if env then
    return "global", env[name]
  else -- no _ENV available
    return "noenv"
  end
end

a = "xx";
print("a =",getvarvalue("a"))
local a = 4;
print("a =", getvarvalue("a"))
print("b =", getvarvalue("b"))
--> a = global  xx
--> a = local   4
--> b = global  nil

local function up(x)
  return function()
    x = x + 0  -- make sure we have upvalue x
    local a, b = getvarvalue("x") -- can't use tail call as it destroys top stack entry
    return a, b  -- therefore we use locals to pass return values from getvarvalue
  end
end

a = up(11)
print("x =", a())
--> x = upvalue 11

local co = coroutine.create(function(c)
  c = c or 123
  local d = 456
  e = 123
  print("Inside coroutine")
  print("c = ", getvarvalue(coroutine.running(),"c"))
  print("d = ", getvarvalue(coroutine.running(),"d"))
  print("e = ", getvarvalue(coroutine.running(),"e"))
--> Inside coroutine
--> c =   local   123
--> d =   local   456
--> e =   global  123

  coroutine.yield()
  f = 444
end)

coroutine.resume(co)

print("Outside coroutine")
print("c = ", getvarvalue(co, "c"))
print("d = ", getvarvalue(co, "d"))
print("e = ", getvarvalue(co, "e"))
print("f = ", getvarvalue(co, "f"))
--> Outside coroutine
--> c =   local   123
--> d =   local   456
--> e =   global  123
--> f =   global  nil
