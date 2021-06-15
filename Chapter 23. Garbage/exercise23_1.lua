--[=[

  Exercise 23.1: Write an experiment to determine whether Lua actually
  implements ephemeron tables. (Remember to call collectgarbage to force a
  garbage collection cycle.) If possible, try your code both in Lua 5.1 and in
  Lua 5.2/5.3 to see the difference.

--]=]

-- Figure 23.1. Constant-function factory with memorization

do
  local mem = {} -- memorization table
  setmetatable(mem, {__mode = "k"})
  function factory (o)
    local res = mem[o]
    if not res then
      res = (function () return o end)
      mem[o] = res
    end
    return res
  end
  -- count how many items there are currently in memorization table
  function inuse ()
    count = 0
    for k,v in pairs(mem) do
      count = count + 1
    end
    return count
  end
end

---[=[ Lua 5.1.5

print(collectgarbage("count") * 1024, inuse()) --> 33315 0

local a = {}

for i = 1, 10000 do
  a[i] = factory{"hello there "..tostring(i)}
end

print(a[100]()[1])                             --> hello there 100
print(collectgarbage("count") * 1024, inuse()) --> 3335674 10000
a = nil
print(collectgarbage("count") * 1024, inuse()) --> 3335706 10000
collectgarbage()
print(collectgarbage("count") * 1024, inuse()) --> 2903206 10000

-- Lua 5.1 does not collect objects from ephemeron table mem

--]=]

--[=[ Lua 5.2.4

print(collectgarbage("count") * 1024, inuse()) --> 29663 0

local a = {}

for i = 1, 10000 do
  a[i] = factory{"hello there "..tostring(i)}
end

print(a[100]()[1])                             --> hello there 100
print(collectgarbage("count") * 1024, inuse()) --> 3148261 10000
a = nil
print(collectgarbage("count") * 1024, inuse()) --> 3148325 10000
collectgarbage()
print(collectgarbage("count") * 1024, inuse()) --> 744399  0

-- Lua 5.2 collects objects from ephemeron table mem

--]=]

--[=[ Lua 5.3.6

print(collectgarbage("count") * 1024, inuse()) --> 28423.0 0

local a = {}

for i = 1, 10000 do
  a[i] = factory{"hello there "..tostring(i)}
end

print(a[100]()[1])                             --> hello there 100
print(collectgarbage("count") * 1024, inuse()) --> 2962567.0 10000
a = nil
print(collectgarbage("count") * 1024, inuse()) --> 2962633.0 10000
collectgarbage()
print(collectgarbage("count") * 1024, inuse()) --> 614180.0  0

-- Lua 5.3 collects objects from ephemeron table mem

--]=]

--[=[ Lua 5.4.2

print(collectgarbage("count") * 1024, inuse()) --> 24670.0 0

local a = {}

for i = 1, 10000 do
  a[i] = factory{"hello there "..tostring(i)}
end

print(a[100]()[1])                             --> hello there 100
print(collectgarbage("count") * 1024, inuse()) --> 2789648.0 10000
a = nil
print(collectgarbage("count") * 1024, inuse()) --> 2789714.0 10000
collectgarbage()
print(collectgarbage("count") * 1024, inuse()) --> 480614.0  0

-- Lua 5.4 collects objects from ephemeron table mem

--]=]

--     5.1            5.2            5.3              5.4         
--   33315 0        29663 0        28423.0 0        24670.0 0    
-- 3335674 10000  3148261 10000  2962567.0 10000  2789648.0 10000
-- 2903206 10000   744399 0       614180.0 0       480614.0 0    
