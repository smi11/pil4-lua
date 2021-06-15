--[=[

  Exercise 18.4: Write an iterator that returns all non-empty substrings of a
  given string.

--]=]

local function nonempty(s)
  local i = 1 -- start position of substring
  local l = 0 -- length of substring

  return function()                       -- iterator function
      l = l + 1                           -- inner loop is length
      if i + l - 1 > #s then
        l = 1
        i = i + 1                         -- outer loop is position
      end
      if i + l - 1 <= #s then             -- if within bounds then return substring
        return string.sub(s, i, i+l-1)
      end
    end
end

for substr in nonempty"abcd" do
  print(substr)
end
--> a
--> ab
--> abc
--> abcd
--> b
--> bc
--> bcd
--> c
--> cd
--> d
