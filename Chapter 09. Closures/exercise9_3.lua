--[=[

  Exercise 9.3: Exercise 5.4 asked you to write a function that receives a
  polynomial (represented as a table) and a value for its variable, and returns
  the polynomial value. Write the curried version of that function. Your
  function should receive a polynomial and return a function that, when called
  with a value for x, returns the value of the polynomial for that x. See the
  example:

  f = newpoly({3, 0, 1})
  print(f(0)) --> 3
  print(f(5)) --> 28
  print(f(10)) --> 103

--]=]

function newpoly(coefficients)
  if not (    type(coefficients) == "table"       -- we must have a table
          and #coefficients > 0            ) then -- with at least 1 coefficient
    return nil                                 -- if not, do not bother calculating
  end
  return function(x)
           if not x then
             return "Value must be provided"
           end
           local n = #coefficients
           local result = 0
           local exp = 1
           for i=n,1,-1 do
             result = result + coefficients[i] * exp
             exp = exp * x
           end
           return result
         end
end

-- in my version I prefer order of coefficients from left to right
f = newpoly{1, 0, 3}
print(f())   --> Value must be provided
print(f(0))  --> 3
print(f(5))  --> 28
print(f(10)) --> 103
