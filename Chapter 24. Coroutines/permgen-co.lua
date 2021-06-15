function printResult (a)
  for i = 1, #a do io.write(a[i], " ") end
  io.write("\n")
end

function permgen (a, n)
  n = n or #a -- default for 'n' is size of 'a'
  if n <= 1 then -- nothing to change?
    coroutine.yield(a)
  else
    for i = 1, n do
      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]
      -- generate all permutations of the other elements
      permgen(a, n - 1)
      -- restore i-th element
      a[n], a[i] = a[i], a[n]
    end
  end
end

function permutations (a)
  local co = coroutine.create(function () permgen(a) end)
  return function () -- iterator
    local code, res = coroutine.resume(co)
    return res
  end
end

-- function permutations (a)
--   return coroutine.wrap(function () permgen(a) end)
-- end

for p in permutations{"a", "b", "c"} do
  printResult(p)
end
