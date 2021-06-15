--[=[

  Exercise 14.1: Write a function to add two sparse matrices.

--]=]

local function add(a, b)
  assert(#a == #b, "Matrices need to have same dimensions")
  local c = {} -- resulting matrix
  for i = 1, #a do
    local resultline = {} -- will be 'c[i]'
    for j, va in pairs(a[i]) do -- 'va' is a[i][j]
      resultline[j] = va -- just copy a[i][j] to c[i][j]
    end
    for j, vb in pairs(b[i]) do -- 'vb' is b[i][j]
      local res = (resultline[j] or 0) + vb -- add b[i][j] to c[i][j] 
      resultline[j] = (res ~= 0) and res or nil
    end
    c[i] = resultline
  end
  return c
end

local function mprint(m)
  for i = 1, #m do
    local row = {}
    for k, v in pairs(m[i]) do
      row[k] = v
    end
    for j = 1, 10 do
      if row[j] then
        io.write(string.format("%2i, ", row[j]))
      else
        io.write("  , ")
      end
    end
    io.write("\n")
  end
end

a = {{},{},{},{},{},{},{},{},{},{}}
b = {{},{},{},{},{},{},{},{},{},{}}
a[5] = {[4]=54, [5]=55}
a[6] = {[8]=11}
a[1] = {8}
b[5] = {[3]=1, [4]=2}
b[6] = {[7]=1}
b[1] = {-8}

c = add(a, b)

mprint(a)
print("+")
mprint(b)
print("=")
mprint(c)

-->  8,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   , 54, 55,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   , 11,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
--> +
--> -8,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,  1,  2,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,  1,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
--> =
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,  1, 56, 55,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,  1, 11,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
-->   ,   ,   ,   ,   ,   ,   ,   ,   ,   , 
