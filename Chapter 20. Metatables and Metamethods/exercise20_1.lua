--[=[

  Exercise 20.1: Define a metamethod __sub for sets that returns the difference
  of two sets. (The set a - b is the set of elements from a that are not in b.)

--]=]

-- Figure 20.1. A simple module for sets

local Set = {}
local mt = {} -- metatable for sets

-- create a new set with the values of a given list
function Set.new (l)
  local set = {}
  setmetatable(set, mt)
  for _, v in ipairs(l) do set[v] = true end
  return set
end

function Set.union (a, b)
  if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
    error("attempt to 'add' a set with a non-set value", 2)
  end
  local res = Set.new{}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

function Set.intersection (a, b)
  if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
    error("attempt to do 'intersection' of set with a non-set value", 2)
  end
  local res = Set.new{}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

function Set.difference (a, b)
  if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
    error("attempt to do 'difference' of set with a non-set value", 2)
  end
  local res = Set.new{}
  for k in pairs(a) do
    if not b[k] then res[k] = true end -- elements from a that are not in b
  end
  return res
end


-- presents a set as a string
function Set.tostring (set)
  local l = {} -- list to put all elements from the set
  for e in pairs(set) do
    l[#l + 1] = tostring(e)
  end
  table.sort(l)
  return "{" .. table.concat(l, ", ") .. "}"
end

mt.__add = Set.union
mt.__sub = Set.difference
mt.__mul = Set.intersection

mt.__le = function (a, b) -- subset
  for k in pairs(a) do
    if not b[k] then return false end
  end
  return true
end

mt.__lt = function (a, b) -- proper subset
  return a <= b and not (b <= a)
end

mt.__eq = function (a, b)
  return a <= b and b <= a
end

mt.__tostring = Set.tostring

return Set
