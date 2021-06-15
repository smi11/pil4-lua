--[=[

  Exercise 21.2: Implement a class StackQueue as a subclass of Stack. Besides
  the inherited methods, add to this class a method insertbottom, which inserts
  an element at the bottom of the stack. (This method allows us to use objects
  of this class as queues.)

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

-- StackQueue class

StackQueue = Stack:new()

function StackQueue:insertbottom(val)
  table.insert(self,1,val)
end

-- Tests

local s2 = StackQueue:new()

print(s2:top(), s2:isempty())     --> nil     true
s2:push(10)
s2:push(20)
s2:push("Hello")
s2:push(30)
s2:insertbottom("bottom")
print(s2:top(), s2:isempty())     --> 30      false
print(s2:pop(), s2:isempty())     --> 30      false
print(s2:pop(), s2:isempty())     --> Hello   false
print(s2:pop(), s2:isempty())     --> 20      false
print(s2:pop(), s2:isempty())     --> 10      false
print(s2:pop(), s2:isempty())     --> bottom  true
