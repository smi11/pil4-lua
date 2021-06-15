--[=[

  Exercise 25.6: Implement some of the suggested improvements for the basic
  profiler that we developed in the section called “Profiles”.

--]=]

local Counters = {}
local Names = {}

-- Figure 25.2. Hook for counting number of calls
local function hook ()
  local f = debug.getinfo(2, "f").func
  local count = Counters[f]
  if count == nil then -- first time 'f' is called?
    Counters[f] = 1
    Names[f] = debug.getinfo(2, "Sn")
  else -- only increment the counter
    Counters[f] = count + 1
  end
end

local fchunk = assert(loadfile(arg[1]))
debug.sethook(hook, "c") -- turn on the hook for calls
fchunk() -- run the main program
debug.sethook() -- turn off the hook

-- remove fchunk() and sethook() from results
Counters[fchunk] = nil
Counters[debug.sethook] = nil

-- Find function in global environment and return its full name
function findfield(func,intbl,depth)
  intbl = intbl or _G
  depth = depth or 0

  for key,val in pairs(intbl) do
    if val == func then return key end
    if type(val) == "table" and depth < 1 then -- just go to depth 1
      local skey = findfield(func,val,depth+1)
      if skey then
        return key == "_G" and skey or key.."."..skey
      end
    end
  end

  return nil
end

-- Figure 25.3. Getting the name of a function
function getname (func)
  local n = Names[func]
  local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
  if n.what == "C" or n.namewhat == "" or n.namewhat == "field" then
    return string.format("%s", findfield(func) or n.name or "?")
  elseif n.what ~= "main" and n.namewhat ~= "" then
    return string.format("%s (%s)", lc, n.name)
  else
    return lc
  end
end

local CountersSorted = {}

for func in pairs(Counters) do
  CountersSorted[#CountersSorted+1] = func
end

table.sort(CountersSorted,function(a,b) return Counters[a] > Counters[b] end)

local pad = tostring(math.floor(math.log10(Counters[CountersSorted[1]])+1))
for _, func in ipairs(CountersSorted) do
  local count = Counters[func]
  io.write(string.format("%"..pad.."i %s\n", count, getname(func)))
end


-- There are several improvements that we can make to this profiler, such as to
-- sort the output, to print better function names, and to embellish the output
-- format.
