--[[

  Exercise 4.9: Redo the previous exercise for UTF-8 strings.

--]]

function ispali(s)
  local s = string.gsub(s,"[%p ]","") -- remove punctations and spaces

  -- build table containing a list of codepoints of UTF8 string s
  local t = {utf8.codepoint(s, 1, -1)}

  -- reverse order of elements in table
  for i = 1,#t // 2 do
    t[i], t[#t-i+1] = t[#t-i+1], t[i] -- swap pair of elements
  end

  -- rebuild reversed UTF8 string from table
  local r = utf8.char(table.unpack(t))

  return s == r
end

-- Caveats:
-- - UTF8 punctation characters are not implemented
-- - Character case conversion is not implemented as that requires huge tables for UTF8

print(ispali("step on no pets"))                  --> true
print(ispali("banana"))                           --> false
print(ispali("was it a car or a cat i saw?"))     --> true
print(ispali("a man, a plan, a canal - panama"))  --> true    (minus character is okay)
print(ispali("a man, a plan, a canal – panama"))  --> false   (unsupported UTF8 hyphen character)
print(ispali("perica reže raci rep"))             --> true
print(ispali("edo suče meč usode."))              --> true
print(ispali("kapelniki že ne vedo ali bo dama dobila od eve nežikin lepak."))  --> true
