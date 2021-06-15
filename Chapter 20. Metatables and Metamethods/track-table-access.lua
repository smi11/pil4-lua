-- Figure 20.2. Tracking table accesses

function track (t)
  local proxy = {} -- proxy table for 't'

  -- create metatable for the proxy
  local mt = {
    __index = function (_, k)
      print("*access to element " .. tostring(k))
      return t[k] -- access the original table
    end,

    __newindex = function (_, k, v)
      print("*update of element " .. tostring(k) .. " to " .. tostring(v))
      t[k] = v -- update original table
    end,

    __pairs = function ()
      return function (_, k) -- iteration function
        local nextkey, nextvalue = next(t, k)
        if nextkey ~= nil then -- avoid last value
          print("*traversing element " .. tostring(nextkey))
        end
        return nextkey, nextvalue
      end
    end,

    __len = function () return #t end
  }

  setmetatable(proxy, mt)
  return proxy
end

t = {} -- an arbitrary table
t = track(t)
t[2] = "hello"
--> *update of element 2 to hello

t[2] = "hello2"
--> *update of element 2 to hello2

print(t[2])
--> *access to element 2
--> hello

t = track({10, 20})
print(#t) --> 2

for k, v in pairs(t) do print(k, v) end
--> *traversing element 1
--> 1 10
--> *traversing element 2
--> 2 20
