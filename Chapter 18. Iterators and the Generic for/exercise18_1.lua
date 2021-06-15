--[=[

  Exercise 18.1: Write an iterator fromto such that the next loop becomes
  equivalent to a numeric for:

    for i in fromto(n, m) do
      body
    end

  Can you implement it as a stateless iterator?

--]=]

-- iterator using closure
local function fromto(n,m)
  i = n - 1
  return function()
      while i < m do
        i = i + 1
        return i
      end
    end
end

-- stateless iterator
local function slnext(m, i) -- we put upper bound m as first argument - invariant state
  i = i + 1
  if i <= m then
    return i
  end
end

local function slfromto(n,m)
  return slnext, m, n-1  -- function, invariant state, control variable
end

for i in fromto(5, 8) do
  print(i)
end
--> 5
--> 6
--> 7
--> 8

for i in slfromto(5, 8) do
  print(i)
end
--> 5
--> 6
--> 7
--> 8
