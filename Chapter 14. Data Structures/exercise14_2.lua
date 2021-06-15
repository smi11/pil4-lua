--[=[

  Exercise 14.2: Modify the queue implementation in Figure 14.2, “A double-ended
  queue” so that both indices return to zero when the queue is empty.

--]=]

function listNew ()
  return {first = 0, last = -1}
end

function pushFirst (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function pushLast (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function popFirst (list)
  local first = list.first
  if first > list.last then
    error("list is empty")
  end
  local value = list[first]
  list[first] = nil -- to allow garbage collection
  list.first = first + 1
  if list.first > list.last then -- empty queue - reset indices
    list.first = 0
    list.last = -1
  end
  return value
end

function popLast (list)
  local last = list.last
  if list.first > last then
    error("list is empty")
  end
  local value = list[last]
  list[last] = nil -- to allow garbage collection
  list.last = last - 1
  if list.first > list.last then -- empty queue - reset indices
    list.first = 0
    list.last = -1
  end
  return value
end

local l = listNew()
pushFirst(l,1)
pushFirst(l,2)
pushFirst(l,3)
print(l.first,l.last)
--> -3      -1  (indices after we added 3 elements)

popLast(l)
popLast(l)
popLast(l)
print(l.first,l.last)
--> 0       -1  (indices after we pulled 3 elements out)

pushLast(l,1)
pushLast(l,2)
pushLast(l,3)
pushFirst(l,1)
pushFirst(l,2)
pushFirst(l,3)
print(l.first,l.last)
--> -3      2  (indices after adding 3 elements from both sides)

for i = 1,6 do
  popFirst(l)
end
print(l.first,l.last)
--> 0       -1  (indices after pulling 6 elements out)

-- list is empty, we'll get an error
popLast(l)
--> lua: exercise14_2.lua:42: list is empty
--> stack traceback:
-->         [C]: in function 'error'
-->         exercise14_2.lua:42: in function 'popLast'
-->         exercise14_2.lua:82: in main chunk
-->         [C]: in ?

