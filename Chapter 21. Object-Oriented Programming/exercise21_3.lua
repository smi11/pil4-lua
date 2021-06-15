--[=[

  Exercise 21.3: Reimplement your Stack class using a dual representation.

--]=]

-- Stack class using dual representation

local StacksData = {} -- We'll keep individual stacks in this table
setmetatable(StacksData, {__mode = "k"})  -- allow removal of orphaned stacks

local Stack = {}

function Stack:new(o)
  o = o or {}
  self.__index = self
  StacksData[o] = {}
  return setmetatable(o, self)
end

function Stack:push(val)
  StacksData[self][#StacksData[self]+1] = val
end

function Stack:pop()
  local top = StacksData[self][#StacksData[self]]
  StacksData[self][#StacksData[self]] = nil
  return top
end

function Stack:top()
  return StacksData[self][#StacksData[self]]
end

function Stack:isempty()
  return #StacksData[self] == 0
end

-- Tests

local s3 = Stack:new()

print(s3:top(), s3:isempty())     --> nil     true
s3:push(10)
s3:push(20)
s3:push("Hello")
s3:push(30)
print(s3:top(), s3:isempty())     --> 30      false
print(s3:pop(), s3:isempty())     --> 30      false
print(s3:pop(), s3:isempty())     --> Hello   false
print(s3:pop(), s3:isempty())     --> 20      false
print(s3:pop(), s3:isempty())     --> 10      true

