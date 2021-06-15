-- Usage: % lua hook main-prog

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

local f = assert(loadfile(arg[1]))
debug.sethook(hook, "c") -- turn on the hook for calls
f() -- run the main program
debug.sethook() -- turn off the hook

-- Figure 25.3. Getting the name of a function
function getname (func)
  local n = Names[func]
  if n.what == "C" then
    return n.name
  end
  local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
  if n.what ~= "main" and n.namewhat ~= "" then
    return string.format("%s (%s)", lc, n.name)
  else
    return lc
  end
end

for func, count in pairs(Counters) do
  print(getname(func), count)
end
