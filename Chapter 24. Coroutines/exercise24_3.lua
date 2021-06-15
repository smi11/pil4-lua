--[=[

  Exercise 24.3: In Figure 24.5, “Running synchronous code on top of the
  asynchronous library”, both the functions getline and putline create a new
  closure each time they are called. Use memorization to avoid this waste.

--]=]

-- Figure 24.5. Running synchronous code on top of the asynchronous library

local lib = require "async-lib"

-- buffer for getline/putline
local mem = {} -- I have modified function for putline so it matches the one from getline
               -- so we could use one buffer for both functions
setmetatable(mem, {__mode = "k"})  -- keys are collectable as they are type "thread"

function run (code)
  local co = coroutine.wrap(function ()
    code()
    lib.stop() -- finish event loop when done
  end)
  co() -- start coroutine
  lib.runloop() -- start event loop
end

function putline (stream, line)
  local co = coroutine.running() -- calling coroutine
  local callback = mem[co]       -- re-use memorized function if available
  if not callback then
    callback = (function (l) coroutine.resume(co, l) end) -- or set it
    mem[co] = callback                                -- and save for later use
  end
  lib.writeline(stream, line, callback)
  coroutine.yield()
end

function getline (stream, line)
  local co = coroutine.running() -- calling coroutine
  local callback = mem[co]
  if not callback then
    callback = (function (l) coroutine.resume(co, l) end)
    mem[co] = callback
  end
  lib.readline(stream, callback)
  local line = coroutine.yield()
  return line
end

run(function ()
  local t = {}
  local inp = io.input()
  local out = io.output()
  while true do
    local line = getline(inp)
    if not line then break end
    t[#t + 1] = line
  end
  for i = #t, 1, -1 do
    putline(out, t[i] .. "\n")
  end
end)
