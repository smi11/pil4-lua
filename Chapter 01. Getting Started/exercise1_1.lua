#!/usr/bin/env lua

--[[

  Exercise 1.1: Run the factorial example. What happens to your program
  if you enter a negative number? Modify the example to avoid this problem.

  - Negative number produces stack overflow error as the recursive call
    have no way to end.

lua: ./fact.lua:8: stack overflow
stack traceback:
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ...
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:8: in function 'fact'
        ./fact.lua:14: in main chunk
        [C]: in ?

  - Example fixed by inserting assert statement to make sure number is provided as
    an argument to the function and that number is integer greater or equal than 0

--]]

-- fixed factorial function
function fact (n)
  assert(type(n)=="number" and
         math.type(n) == "integer" and
         n >= 0, "integer larger than or equal to 0 expected")
  if n == 0 then
    return 1
  else
    return n * fact(n - 1)
  end
end

print("enter a number:")
a = io.read("*n") -- reads a number
print(fact(a))
