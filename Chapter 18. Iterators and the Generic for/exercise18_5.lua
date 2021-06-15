--[=[

  Exercise 18.5: Write a true iterator that traverses all subsets of a given
  set. (Instead of creating a new table for each subset, it can use the same
  table for all its results, only changing its contents between iterations.)

--]=]

-- caveat: this only work for sets with up to 64 items in standard lua
-- as we are using integer bits to represent items of set
local function subsets(t, f)
  local bits = #string.pack("j",0) * 8 -- get number of bits of integer
  assert( #t <= bits, "subsets only work for sets with up to "..tostring(bits).." items" )
  local res = {}
  local comb = ( 1 << #t ) - 1  -- 2^#t - 1 = number of combinations
  for set = 1, comb do -- ignore first empty set by starting with 1 instead of 0
    for i = 1, #t do res[i] = nil end -- erase result table
    for i = 1, #t do
      if ( 1 << (i-1) ) & set > 0 then -- examine active bits and copy corresponding
        res[#res+1] = t[i]             -- items to results table
      end
    end
    f(res)
  end
end

local function printset(t)
  io.write("{ ")
  for i, v in ipairs(t) do
    io.write(string.format("%q",v), i < #t and ", " or "") -- item and comma when needed
  end
  io.write(" }\n")
end

subsets({ "item 1","item 2", "item 3"}, printset)
--> { "item 1" }
--> { "item 2" }
--> { "item 1", "item 2" }
--> { "item 3" }
--> { "item 1", "item 3" }
--> { "item 2", "item 3" }
--> { "item 1", "item 2", "item 3" }
