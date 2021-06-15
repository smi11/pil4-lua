--[=[

  Exercise 5.5: Can you write the function from the previous item so that it
  uses at most n additions and n multiplications (and no exponentiations)?

--]=]

function polynomial(coefficients, x)
  x = x or 1        -- if x is not provided assume 1

  if not (    type(coefficients) == "table"    -- we must have a table
          and #coefficients > 0                -- with at least 1 coefficient
          and type(x) == "number") then        -- and x must be a number
    return nil                                 -- if not, do not bother calculating
  end

  local result = 0
  local exp = 1
  local n = #coefficients

  for i=n,1,-1 do
    result = result + coefficients[i] * exp
    exp = exp * x
  end

  return result
end

print(polynomial())               --> nil     (Invalid polynomial - no table, no x)
print(polynomial({}))             --> nil     (Invalid polynomial - no coefficients)
print(polynomial({1}))            --> 1       (one coefficient, x is irrelevant)
print(polynomial({10}))           --> 10      (one coefficient, x is irrelevant)
print(polynomial({1,1}, 1))       --> 2       (1x + 1 where x = 1)
print(polynomial({1,1}, 5))       --> 6       (1x + 1 where x = 5)
print(polynomial({2,5}, 1))       --> 7       (2x + 5 where x = 1)
print(polynomial({1,1}))          --> 2       (1x + 1 where x = 1, default x = 1)
print(polynomial({1,1}, "a"))     --> nil     (Invalid polynomial - x not a number)
print(polynomial({1,2,3}, 50))    --> 2603    (1x^2 + 2x + 3 where x = 50)
print(polynomial({3,2,1}, 10))    --> 321     (3x^2 + 2x + 1 where x = 10)
print(polynomial({1,0,1,0}, 2))   --> 10      (1x^3 + 0x^2 + 1x + 0 where x = 2)
