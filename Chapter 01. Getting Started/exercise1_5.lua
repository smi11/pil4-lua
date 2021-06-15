--[[

  Exercise 1.5: What is the value of the expression type(nil) == nil?
  (You can use Lua to check your answer.) Can you explain this result?

  - Expression evaluates to false

    Function 'type' always returns string. Comparing string to nil is false.

--]]

print(type(nil) == nil)               --> false          (boolean value)

print(type(type(nil)), type(nil))     --> string    nil  (both are string)

print(nil)                            --> nil            (nil value)
