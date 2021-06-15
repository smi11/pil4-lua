--[=[

  Exercise 5.4: We can represent a polynomial
  a_n x^n + a_n-1 x^n-1 + ... + a_1 x^1 + a_0 in Lua as a list of its
  coefficients, such as {a0, a1, ..., an }.

  Write a function that takes a polynomial (represented as a table) and a
  value for x and returns the polynomial value.

--]=]

function polynomial(coefficients, x)
  x = x or 1        -- if x is not provided assume 1

  if not (    type(coefficients) == "table"    -- we must have a table
          and #coefficients > 0                -- with at least 1 coefficient
          and type(x) == "number") then        -- and x must be a number
    return nil                                 -- if not, do not bother calculating
  end

  local result = 0
  local n = #coefficients

  for i=1,n do
    result = result + coefficients[i] * x^(n-i)
  end

  return result
end

print(polynomial())               --> nil     (Invalid polynomial - no table, no x)
print(polynomial({}))             --> nil     (Invalid polynomial - no coefficients)
print(polynomial({1}))            --> 1.0     (one coefficient, x is irrelevant)
print(polynomial({10}))           --> 10.0    (one coefficient, x is irrelevant)
print(polynomial({1,1}, 1))       --> 2.0     (x + 1 where x = 1)
print(polynomial({1,1}, 5))       --> 6.0     (x + 1 where x = 5)
print(polynomial({2,5}, 1))       --> 7.0     (2x + 5 where x = 1)
print(polynomial({1,1}))          --> 2.0     (x + 1 where x = 1)
print(polynomial({1,1}, "a"))     --> nil     (Invalid polynomial - x not a number)
print(polynomial({1,2,3}, 50))    --> 2603.0  (1x^2 + 2x + 3 where x = 50)
print(polynomial({3,2,1}, 10))    --> 321.0   (3x^2 + 2x + 1 where x = 10)
print(polynomial({1,0,1,0}, 2))   --> 10.0    (1x^3 + 0x^2 + 1x + 0 where x = 2)
