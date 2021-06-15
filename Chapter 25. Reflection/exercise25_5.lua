--[=[

  Exercise 25.5: Improve the previous exercise to handle updates, too.

--]=]


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

function mydebug()
  local mt = {
    __index = function (t, k)
      local _, val = getvarvalue(k, 4)
      return val
    end,
    __newindex = function (t, k, v)
      setvarvalue(k, v, 4)
    end
  }
  local env = {}
  setmetatable(env, mt)
  while true do
    io.write("lua_debug>")
    local line = io.read()
    if line == "cont" then
      return
    else
      local f = assert(load(line))
      debug.setupvalue(f, 1, env)
      f()
    end
  end
end

function test()
  local a = "aaa"
  local function add(a,b)
    mydebug()
    return a..b
  end
  local res = add(a,"bbb")
  mydebug()
  print(res)
end

test()
