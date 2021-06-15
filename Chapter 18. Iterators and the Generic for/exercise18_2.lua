--[=[

  Exercise 18.2: Add a step parameter to the iterator from the previous
  exercise. Can you still implement it as a stateless iterator?

--]=]

-- iterator using closure
local function fromto(n,m,step)
  step = step or 1
  i = n - step
  return function()
      while i + step <= m do
        i = i + step
        return i
      end
    end
end

-- stateless iterator
local function slnext(t, i) -- invariant state is table t with keys m and step
  i = i + t.step
  if i <= t.m then
    return i
  end
end

-- we can use invariant state as a table and save keys for m and step there
local function slfromto(n,m,step)
  step = step or 1
  return slnext, {m=m, step=step}, n-step  -- function, invariant state, control variable
end

for i in fromto(4,10,3) do
  print(i)
end
--> 4
--> 7
--> 10

for i in slfromto(3,10,3) do
  print(i)
end
--> 3
--> 6
--> 9
