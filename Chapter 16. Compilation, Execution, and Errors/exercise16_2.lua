--[=[

  Exercise 16.2: Write a function multiload that generalizes loadwithprefix by
  receiving a list of readers, as in the following example:

    f = multiload("local x = 10;",
                  io.lines("temp", "*L"),
                  "print(x)")

  In the above example, multiload should load a chunk equivalent to the
  concatenation of the string "local...", the contents of the temp file, and the
  string "print(x)". Like loadwithprefix, from the previous exercise, multiload
  should not actually concatenate anything.

--]=]

local function multiload(...)
  local arg = table.pack(...)
  local n = 1         -- counter for which argument to return
  local last = arg.n  -- number of items provided by table.pack

  local function reader()
    while n <= last do
      local tn = type(arg[n])
      if tn == "function" then
        local ret = arg[n]() -- call reader function
        if ret ~= nil then
          return ret         -- while arg[n]() produces values, keep returning them
        else
          n = n + 1          -- exhausted reader function, so skip to next arg item
        end
      elseif tn == "string" then
        n = n + 1             -- before we do return, we need to increment n
        return arg[n-1]       -- and of course return previous item, hence arg[n-1]
      elseif tn == "nil" then -- allow explicit nil as argument
        return nil            -- that will break the loop even if more items afterwards
      else
        error("Only strings and functions allowed, but argument "..tostring(n).." is "..tn)
      end
    end
    return nil -- no more items
  end

  return load(reader)
end

function test(n)
  return function()
           while n > 0 do
             n = n - 1
             return "print("..tostring(n+1)..")"
           end
           return nil
         end
end

local count = test(3)

local f = assert(multiload("local x = 10;",
                           io.lines("./test16_2.txt", "*L"),
                           "print(x)",
                           count,
                           "print('All done')"))
f()
--> Count   1   (local x = 10; io.lines("./test16_2.txt", "*L"))
--> Count   2
--> Count   3
--> 10          (print(x))
--> 3           (count)
--> 2
--> 1
--> All done    (print('All done'))
