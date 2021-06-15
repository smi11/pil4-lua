--[=[

  Exercise 23.4: Explain the output of the program in Figure 23.3, “Finalizers
  and memory”.

    -- Figure 23.3. Finalizers and memory

    local count = 0
    local mt = {__gc = function () count = count - 1 end}
    local a = {}
    for i = 1, 10000 do
      count = count + 1
      a[i] = setmetatable({}, mt)
    end
    collectgarbage()
    print(collectgarbage("count") * 1024, count)
    a = nil
    collectgarbage()
    print(collectgarbage("count") * 1024, count)
    collectgarbage()
    print(collectgarbage("count") * 1024, count)

--]=]

-- Figure 23.3. Finalizers and memory

-- count alive objects
local count = 0

-- when collector finalizes object, decrement counter of alive objects
local mt = {__gc = function () count = count - 1 end}

-- we'll keep collection of objects in a
local a = {}

-- create 10000 objects
for i = 1, 10000 do
  count = count + 1            -- Increment count for each object added to a
  a[i] = setmetatable({}, mt)  -- Create and assign finalizer to that object
end

-- manually force collector to run, however nothing will be collected
-- since all objects have strong references
collectgarbage()

-- since all objects are alive (references from a to each object) we should see
-- how much memory they are all using and our count should show 10000 alive objects
print(collectgarbage("count") * 1024, count) --> 846685.0        10000

-- dispose of entire collection a with 10000 objects
a = nil

-- force collector (phase 1 for objects with finalizers)
collectgarbage()

-- since Lua collect objects with finalizers in two phases
-- after this phase 10000 objects will be queued to be finalized
-- all of them have been temporarily resurrected and their finalizers were run
-- hence our counter 'count' should be back to 0
print(collectgarbage("count") * 1024, count) --> 584485.0        0

-- force collector (phase 2 for objects with finalizers)
collectgarbage()

-- in second phase objects are actually removed and the memory is freed
print(collectgarbage("count") * 1024, count) --> 24461.0        0
