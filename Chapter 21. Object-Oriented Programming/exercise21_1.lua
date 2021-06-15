--[=[

  Exercise 21.1: Implement a class Stack, with methods push, pop, top, and
  isempty.

--]=]

-- Stack class

local Stack = {}

function Stack:new(o)
  o = o or {}
  self.__index = self
  return setmetatable(o, self)
end

function Stack:push(val)
  self[#self+1] = val
end

function Stack:pop()
  local top = self[#self]
  self[#self] = nil
  return top
end

function Stack:top()
  return self[#self]
end

function Stack:isempty()
  return #self == 0
end

-- Tests

local s1 = Stack:new()

print(s1:top(), s1:isempty())     --> nil     true
s1:push(10)
s1:push(20)
s1:push("Hello")
s1:push(30)
print(s1:top(), s1:isempty())     --> 30      false
print(s1:pop(), s1:isempty())     --> 30      false
print(s1:pop(), s1:isempty())     --> Hello   false
print(s1:pop(), s1:isempty())     --> 20      false
print(s1:pop(), s1:isempty())     --> 10      true

