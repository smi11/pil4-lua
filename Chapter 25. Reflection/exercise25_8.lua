--[=[

  Exercise 25.8: One problem with the sandbox in Figure 25.6, “Using hooks to
  bar calls to unauthorized functions” is that sandboxed code cannot call its
  own functions. How can you correct this problem?

--]=]

-- Figure 25.6. Using hooks to bar calls to unauthorized functions

local debug = require "debug"

-- maximum "steps" that can be performed
local steplimit = 1000
local count = 0 -- counter for steps

-- set of authorized functions
local validfunc = {
[math.floor] = true,
[tostring] = true,
[io.write] =true,
[print] = true,
-- other authorized functions
}
-- set authorized chunks
local validchunk = {}

local function hook (event)
  if event == "call" then
    local info = debug.getinfo(2, "fnS")
    -- check for allowed functions and chunks?
    if not validfunc[info.func] and not validchunk[info.short_src] then
      error("calling bad function: " .. (info.name or "?"))
    end
  end
  count = count + 1
  if count > steplimit then
    error("script uses too much CPU")
  end
end

-- load chunk (environment set with needed functions for test.lua)
local f = assert(loadfile(arg[1], "t", {io = io, math=math, tostring=tostring}))

validchunk[arg[1]] = true  -- allow all functions from chunk arg[1]

debug.sethook(hook, "c", 100) -- set hook for "call" and "count" events
f() -- run chunk
print(count)  -- how many steps did we use?
--> 969    (depends on file we used)
