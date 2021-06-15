--[=[

  Exercise 25.4: Write an improved version of debug.debug that runs the given
  commands as if they were in the lexical scope of the calling function. (Hint:
  run the commands in an empty environment and use the __index metamethod
  attached to the function getvarvalue to do all accesses to variables.)

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

function mydebug()
  local mt = {
    __index = function (t, k)
      local _, val = getvarvalue(k, 4)
      return val
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
