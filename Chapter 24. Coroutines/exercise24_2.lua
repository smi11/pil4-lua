--[=[

  Exercise 24.2: Exercise 6.5 asked you to write a function that prints all
  combinations of the elements in a given array. Use coroutines to transform
  this function into a generator for combinations, to be used like here:

    for c in combinations({"a", "b", "c"}, 2) do
      printResult(c)
    end

--]=]

local function printResult(c)
  io.write(table.concat(c, ", "), "\n")
end

local function comb(arr, m, top)
  top = not top      -- flag to discern if we are at top level or in a recursive call
  m = m or #arr      -- default m = n = #arr; n is actually #arr so we don't need it
  local ret = {}     -- we'll build combinations of arr here

  if #arr < m then   -- n is smaller then m, no combinations
    return {}
  end

  if m == 0 then     -- one combination with no elements
    return {{}}
  end

  local remain = table.move(arr,2,#arr,1,{})  -- slice first element away
  local sub = comb(remain, m-1, true)  -- generate C(n-1, m-1)

  -- for each combination found insert back first element of arr and save it to ret
  for k,onecomb in ipairs(sub) do
    table.insert(onecomb,1,arr[1])
    ret[#ret+1] = onecomb
    if top then                -- only top level combinations are actuall results
      coroutine.yield(onecomb) -- return each combination found
    end
  end

  sub = comb(remain, m, true)  -- generate C(n-1, m)

  -- save all found combinations to ret
  for k,onecomb in ipairs(sub) do
    ret[#ret+1] = onecomb
    if top then                -- only top level combinations are actuall results
      coroutine.yield(onecomb) -- return each combination found
    end
  end

  return ret -- array with all found combinations
end

local function combinations(arr, m)
  return coroutine.wrap(function () comb(arr, m) end)
end

for c in combinations({"a", "b", "c"}, 2) do
  printResult(c)
end
--> a, b
--> a, c
--> b, c
