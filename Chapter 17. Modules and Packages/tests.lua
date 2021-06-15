local q = require"exercise17_1"
local f = require"exercise17_2"

local l = q.listNew()
q.pushFirst(l,1)
q.pushFirst(l,2)
q.pushFirst(l,3)
print(l.first,l.last)
--> -3      -1  (indices after we added 3 elements)

q.popLast(l)
q.popLast(l)
q.popLast(l)
print(l.first,l.last)
--> 0       -1  (indices after we pulled 3 elements out)

q.pushLast(l,1)
q.pushLast(l,2)
q.pushLast(l,3)
q.pushFirst(l,1)
q.pushFirst(l,2)
q.pushFirst(l,3)
print(l.first,l.last)
--> -3      2  (indices after adding 3 elements from both sides)

for i = 1,6 do
  q.popFirst(l)
end
print(l.first,l.last)
--> 0       -1  (indices after pulling 6 elements out)

c1 = f.disk(0, 0, 1)
-- rotate the crescent moon by -45 degrees
f.plot(f.rotate(f.difference(c1, f.translate(c1, 0.3, 0)),-45), 25, 15)
