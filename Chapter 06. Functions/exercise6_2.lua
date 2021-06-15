--[=[

  Exercise 6.2: Write a function that takes an arbitrary number of values and
  returns all of them, except the first one.

--]=]

function nofirst1(dummy, ...)
  return ...
end

function nofirst2(...)
  return select(2,...)
end

print(nofirst1(1,2,nil,3,4))  --> 2   nil  3   4
print(nofirst1(1,2,nil,3))    --> 2   nil  3
print(nofirst1(1,2,nil))      --> 2   nil
print(nofirst1(1,2))          --> 2
print(nofirst1(1))            --> (no return values)
print(nofirst1())             --> (no return values)

print(nofirst2(1,2,nil,3,4))  --> 2   nil  3   4
print(nofirst2(1,2,nil,3))    --> 2   nil  3
print(nofirst2(1,2,nil))      --> 2   nil
print(nofirst2(1,2))          --> 2
print(nofirst2(1))            --> (no return values)
print(nofirst2())             --> (no return values)
