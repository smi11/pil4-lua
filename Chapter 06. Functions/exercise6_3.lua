--[=[

  Exercise 6.3: Write a function that takes an arbitrary number of values and
  returns all of them, except the last one.

--]=]

function nolast1(...)
  local t = table.pack(...)            -- pack arguments into table
  return table.unpack(t, 1, t.n-1)     -- unpack elements from 1 to tablesize-1
end

-- using recursion and select
function nolast2(...)
  local function build(i,...)
    i = i or 1
    if i < select("#",...) then
      return select(i,...), build(i + 1, ...)
    end
  end
  return build(1,...)
end

print(nolast1(1,2,nil,3,4))   --> 1   2   nil  3
print(nolast1(1,2,nil,3))     --> 1   2   nil
print(nolast1(1,2,nil))       --> 1   2
print(nolast1(1,2))           --> 1
print(nolast1(1))             -->                (no return values)
print(nolast1())              -->                (no return values)


print(nolast2(1,2,nil,3,4))   --> 1   2   nil  3
print(nolast2(1,2,nil,3))     --> 1   2   nil
print(nolast2(1,2,nil))       --> 1   2
print(nolast2(1,2))           --> 1
print(nolast2(1))             -->                (no return values)
print(nolast2())              -->                (no return values)
