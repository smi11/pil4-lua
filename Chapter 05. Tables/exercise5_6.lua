--[=[

  Exercise 5.6: Write a function to test whether a given table is a valid
  sequence.

--]=]

-- A sequence is a table with list of elements with sequential integer keys
-- It can have 0 or more elements starting with integer key 1

-- This function doesn't allow mixing a sequence with elements with non-integer keys
-- If sequence contains a hole, it is not a proper sequence
function issequence(t)

  if type(t) ~= "table" then  -- if t is not table then it's also not a sequence
    return false
  end

  -- count number of all keys in table (both integer and non-integer keys)
  local count = 0
  for k, v in pairs(t) do
    count = count + 1
  end

  -- if count is equal to Lua's table size it means the table is only a sequence
  -- anything else means there are holes in sequence and/or there are other
  -- non-integer key/value pairs
  return count == #t
end

-- This version is much faster but less accurate. It allows for holes and/or other
-- non-integer key/value pairs together with proper sequence.
-- It only rejects exclusive non-integer key/value pairs without any sequence
function issequence2(t)
  return type(t) == 'table' and (#t > 0 or next(t) == nil)
end

print("Algorithm 1 - accurate")
print(issequence({}))                   --> true   (empty sequence is okay)
print(issequence({ 1, 2, 3 }))          --> true
print(issequence({ 3, 2, 1 }))          --> true
print(issequence({ 3, nil, 1 }))        --> false  (hole in sequence)
print(issequence({ 3, 2, 1, nil }))     --> true   (last nil ignored by table constructor)
print(issequence({ "a", "b" }))         --> true
print(issequence({ "a", "b", 1, 2 }))   --> true
print(issequence({ "a", "b", x=1 }))    --> false  (mixed entries not allowed)
print(issequence({ x=1, y=2 }))         --> false  (not a sequence)
print(issequence({ [2]=1, [3]=2 }))     --> false  (sequence does not start with index 1)

print("\nAlgorithm 2 - less accurate but faster")
print(issequence2({}))                   --> true   (empty sequence is okay)
print(issequence2({ 1, 2, 3 }))          --> true
print(issequence2({ 3, 2, 1 }))          --> true
print(issequence2({ 3, nil, 1 }))        --> true   (hole not detected)
print(issequence2({ 3, 2, 1, nil }))     --> true   (last nil ignored by table constructor)
print(issequence2({ "a", "b" }))         --> true
print(issequence2({ "a", "b", 1, 2 }))   --> true
print(issequence2({ "a", "b", x=1 }))    --> true   (mixed keys not detected)
print(issequence2({ x=1, y=2 }))         --> false  (not a sequence)
print(issequence2({ [2]=1, [3]=2 }))     --> false  (sequence does not start with index 1)
