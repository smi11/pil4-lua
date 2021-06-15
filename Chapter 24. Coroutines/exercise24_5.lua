--[=[

  Exercise 24.5: Can you use the coroutine-based library (Figure 24.5, “Running
  synchronous code on top of the asynchronous library”) to run multiple threads
  concurrently? What would you have to change?

--]=]

-- Figure 24.5. Running synchronous code on top of the asynchronous library

local lib = require "async-lib"
local tasks = 0 -- number of running tasks

function run (code)
  local co = coroutine.wrap(function ()
    code()
    -- code finished, do cleanup
    tasks = tasks - 1 -- decrement number of running tasks
    if tasks == 0 then
      lib.stop() -- finish event loop when all tasks are done
    end
  end)
  tasks = tasks + 1 -- increment number of running tasks
  co() -- run this task
end

function putline (stream, line)
  local co = coroutine.running() -- calling coroutine
  local callback = (function () coroutine.resume(co) end)
  lib.writeline(stream, line, callback)
  coroutine.yield()
end

function getline (stream, line)
  local co = coroutine.running() -- calling coroutine
  local callback = (function (l) coroutine.resume(co, l) end)
  lib.readline(stream, callback)
  local line = coroutine.yield()
  return line
end

-- task 1; cat this file in reverse to stdout
run(function ()
  local t = {}
  local inp = assert(io.open("exercise24_5.lua","r"))
  local out = io.output()
  while true do
    local line = getline(inp)
    if not line then break end
    t[#t + 1] = line
  end
  for i = #t, 1, -1 do
    putline(out, "1> " .. t[i] .. "\n")
  end
end)

-- task 2; echo lines from stdin to stdout
run(function ()
  local inp = io.input()
  local out = io.output()
  while true do
    local line = getline(inp)
    if not line then break end
    putline(out, "2> " .. line .. "\n")
  end
end)

-- task 3; cat this file to stdout
run(function ()
  local inp = assert(io.open("exercise24_5.lua","r"))
  local out = io.output()
  while true do
    local line = getline(inp)
    if not line then break end
    putline(out, "3> " .. line .. "\n")
  end
end)

lib.runloop() -- run event loop
