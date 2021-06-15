--[=[

  Exercise 8.2: Describe four different ways to write an unconditional loop in
  Lua. Which one do you prefer?

  - We can make loop using for, while, repeat or goto statement. I have listed
    them in order of how frequently I use them. Otherwise I have no preference.
    It depends on what I want to achieve and which type of loop suits most
    to my desired outome.

--]=]

-- 1. using for statement

for i = 1, math.maxinteger do
  -- body
end

-- 2. using while statement

while true do
  -- body
end

-- 3. using repeat statement

repeat
  -- body
until false

-- 4. using goto statement

::loop:: 
-- body
goto loop
