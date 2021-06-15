--[=[

  Exercise 24.4: Write a line iterator for the coroutine-based library (Figure
  24.5, “Running synchronous code on top of the asynchronous library”), so that
  you can read the file with a for loop.

--]=]

local lib = require "async-lib"

local function run (code)
  local co = coroutine.wrap(function ()
    code()
    lib.stop() -- finish event loop when done
  end)
  co() -- start coroutine
  lib.runloop() -- start event loop
end

local function getline (stream)
  local co = coroutine.running() -- calling coroutine
  local callback = (function (l) coroutine.resume(co, l) end)
  lib.readline(stream, callback)
  local line = coroutine.yield()
  if line == nil then -- close stream when we are done
    stream:close()
  end
  return line
end

-- iterator function for getline
local function lines(fn)
  local inp = assert(io.open(fn, "r"))
  return getline, inp
end

run(function ()
  for line in lines("exercise24_4.lua") do
    print(line)
  end
end)
