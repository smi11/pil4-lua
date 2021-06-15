--[[

  Exercise 1.6: How can you check whether a value is a Boolean without
  using the function type?

--]]

-- comparing value to not not value gives as what we need
-- when we do double logical not to 'any boolean value', we get exactly the same boolean value
-- that is not true for any other data type
function isboolean(v)
  return v == not not v
end

print(isboolean(true))      --> true
print(isboolean(false))     --> true
print(isboolean(10))        --> false     (integer)
print(isboolean(10.1))      --> false     (float)
print(isboolean("string"))  --> false     (string)
print(isboolean(nil))       --> false     (nil)
print(isboolean(print))     --> false     (function)
