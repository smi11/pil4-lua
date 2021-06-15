--[=[

  Exercise 20.3: An alternative way to implement read-only tables might use a
  function as the __index metamethod. This alternative makes accesses more
  expensive, but the creation of read-only tables is cheaper, as all read-only
  tables can share a single metatable. Rewrite the function readOnly using this
  approach.

--]=]

local key = {}
local mt = {
  __index = function (t,i)
    return t[key][i]
  end,
  __newindex = function (t, k, v)
    error("attempt to update a read-only table", 2)
  end
}

function readOnly (t)
  local proxy = {}
  proxy[key] = t
  setmetatable(proxy, mt)
  return proxy
end

days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

print(days[1]) --> Sunday
days[2] = "Noday"
--> lua: exercise20_3.lua:32: attempt to update a read-only table
--> stack traceback:
-->         [C]: in function 'error'
-->         exercise20_3.lua:17: in metamethod '__newindex'
-->         exercise20_3.lua:31: in main chunk
-->         [C]: in ?
