--[=[

  Exercise 6.5: Write a function that takes an array and prints all combinations
  of the elements in the array. (Hint: you can use the recursive formula for
  combination: C(n,m) = C(n - 1, m - 1) + C(n - 1, m). To generate all C(n,m)
  combinations of n elements in groups of size m, you first add the first element
  to the result and then generate all C(n - 1, m - 1) combinations of the
  remaining elements in the remaining slots; then you remove the first element
  from the result and then generate all C(n - 1, m) combinations of the remaining
  elements in the free slots. When n is smaller than m, there are no combinations.
  When m is zero, there is only one combination, which uses no elements.)

--]=]

-- helper function to print list of found combinations
function plist(list)
  for i,arr in ipairs(list) do
    print(table.unpack(arr))
  end
end

function combinations(arr, m)
  m = m or #arr      -- default m = n = #arr; n is actually #arr so we don't need it
  local ret = {}     -- we'll build combinations of arr here

  if #arr < m then   -- n is smaller then m, no combinations
    return {}
  end

  if m == 0 then     -- one combination with no elements
    return {{}}
  end

  local remain = table.move(arr,2,#arr,1,{})  -- slice first element away
  local sub = combinations(remain, m-1)  -- generate C(n-1, m-1)

  -- for each combination found insert back first element of arr and save it to ret
  for k,onecomb in ipairs(sub) do
    table.insert(onecomb,1,arr[1])
    ret[#ret+1] = onecomb
  end

  sub = combinations(remain, m)  -- generate C(n-1, m)

  -- save all found combinations to ret
  for k,onecomb in ipairs(sub) do
    ret[#ret+1] = onecomb
  end

  return ret
end

plist(combinations({1,2,3,4,5},3)) -- five elements in groups of 3
--> 1 2 3
--> 1 2 4
--> 1 2 5
--> 1 3 4
--> 1 3 5
--> 1 4 5
--> 2 3 4
--> 2 3 5
--> 2 4 5
--> 3 4 5

plist(combinations({"dog","cat","mouse"},2)) -- three elements in groups of 2
--> dog cat
--> dog mouse
--> cat mouse

plist(combinations({1,2,3})) -- three elements in group of 3
--> 1 2 3

plist(combinations({"dog","cat","mouse","cow"},3)) -- four elements in groups of 3
--> dog cat   mouse
--> dog cat   cow
--> dog mouse cow
--> cat mouse cow

plist(combinations({"dog","cat","mouse","cow"},1)) -- four elements in groups of 1
--> dog
--> cat
--> mouse
--> cow

plist(combinations({1,2,3,4,5},2)) -- five elements in groups of 2
--> 1 2
--> 1 3
--> 1 4
--> 1 5
--> 2 3
--> 2 4
--> 2 5
--> 3 4
--> 3 5
--> 4 5
