--[=[

  Exercise 16.4: Can you find any value for f such that the call pcall(pcall, f)
  returns false as its first result? Why is this relevant?

--]=]

-- pcall always returns status as first return value
-- and either result or error message
-- true, result
-- false, error message

local status, result_or_errormsg = pcall(function() return "something" end)
print(status, result_or_errormsg)
--> true    something

local status, result_or_errormsg = pcall(function() error("big mistake") end)
print(status, result_or_errormsg)
--> false   exercise16_4.lua:17: big mistake

-- if we do outer pcall on inner pcall regardless if inner pcalls function produces
-- error or not the outer pcall will always succeed and return true
-- so we'll have a stack of return values:
-- true, true or false, something or error message

f = function() return "something" end
local statusouter, statusinner, result_or_errormsg = pcall(pcall, f)
print(statusouter, statusinner, result_or_errormsg)
--> true    true    something

f = function() error("big mistake") end
local statusouter, statusinner, result_or_errormsg = pcall(pcall, f)
print(statusouter, statusinner, result_or_errormsg)
--> true    false   exercise16_4.lua:31: big mistake

-- because outer pcall will always succeed, we'll get always true as a first result
-- since pcall never raises an error it is impossible for outer pcall to return false
-- unless we do some tricks with debug library and insert an error in between 
-- inner and outer pcall by using sethook function.
-- This implementation is by Pierre Chapuis
-- http://lua-users.org/lists/lua-l/2013-01/msg00577.html

local f = function()
  local second = false
  local h = function()
    if c then debug.sethook(nil,"r") end
    c = not c
    error()
  end
  debug.sethook(h,"r")
end

local statusouter, statusinner, result_or_errormsg = pcall(pcall, f)
print(statusouter, statusinner, result_or_errormsg)
--> false   nil     nil
