--[=[

  Exercise 10.7: Write a function to reverse a UTF-8 string.

--]=]

function reverse(s)
  -- build table containing a list of codepoints of UTF8 string s
  local t = {utf8.codepoint(s, 1, -1)}

  -- reverse order of elements in table
  for i = 1,#t // 2 do
    t[i], t[#t-i+1] = t[#t-i+1], t[i] -- swap pair of elements
  end

  -- rebuild reversed UTF8 string from table and return it
  return utf8.char(table.unpack(t))
end

print(reverse("력사 역노"))
--> 노역 사력

print(reverse("Lačni žafran"))
--> narfaž inčaL
