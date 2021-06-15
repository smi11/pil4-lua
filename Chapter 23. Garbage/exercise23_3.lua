--[=[

  Exercise 23.3: Imagine you have to implement a memorizing table for a function
  from strings to strings. Making the table weak will not do the removal of
  entries, because weak tables do not consider strings as collectable objects.
  How can you implement memorization in that case?

--]=]

do
  -- keys will be strings, values will be a string stored in a table, so it is collectible
  -- if we used only strings for values as well, nothing would be collected

  local mem = {} -- memorization table
  setmetatable(mem, {__mode = "v"}) -- we need weak values as we'll store strings into table


  count = 0 -- how many times we called function triples?
  function triples (s)  -- test function
    count = count + 1
    return string.format("%s-%s-%s", s, s, s)
  end

  function memstr (s)
    local res = mem[s]
    if not res then
      res = {val=triples(s)}   -- we store string into table, so it is collectible
      mem[s] = res
    end
    return res.val -- return only string
  end

  -- count how many items there are currently in memorization table
  function inuse ()
    local c = 0
    for k,v in pairs(mem) do
      c = c + 1
    end
    return c
  end
end

-- collectgarbage("stop") -- uncomment for explanation of last operation

print(collectgarbage("count") * 1024, inuse()) --> 28005.0 0

local a = {}

for i = 1, 10000 do
  a[i] = memstr("hello"..tostring(i)) -- call memstr several times
  a[i] = memstr("hello"..tostring(i)) -- just to demonstrate that
  a[i] = memstr("hello"..tostring(i)) -- function triples is called
  a[i] = memstr("hello"..tostring(i)) -- only once for one particular
  a[i] = memstr("hello"..tostring(i)) -- item
end

print(a[100])                                  --> hello100-hello100-hello100

-- before we fully fill our table a, there was already garbage collection cycle
-- therefore our counter inuse() does not show all 10000 items
-- some items were already collected
print(collectgarbage("count") * 1024, inuse()) --> 2236226.0       5247
collectgarbage()

-- now after explicit call for garbage collection all items from table mem
-- were collected
print(collectgarbage("count") * 1024, inuse()) --> 1525507.0       0

-- our array a is still present as we didn't remove it
print(a[101])                                  --> hello101-hello101-hello101

-- because there was one collection cycle before building the whole array a
-- for one item we called function triples twice and therefore our counter
-- shows one more item.
-- if we disable garbage collection at the beginning this count will be 10000
print(count)                                   --> 10001
