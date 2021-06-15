--[[

  Exercise 4.8: Redo the previous exercise so that it ignores differences
  in spaces and punctuation.

--]]

function ispali(s)
  local s = string.gsub(s,"[%p ]","") -- remove punctations and spaces
  return s == string.reverse(s)
end

print(ispali("step on no pets"))                  --> true
print(ispali("banana"))                           --> false
print(ispali("was it a car or a cat i saw?"))     --> true
print(ispali("a man, a plan, a canal - panama"))  --> true    (minus character is okay)
print(ispali("a man, a plan, a canal – panama"))  --> false   (unsupported UTF8 hyphen character)
print(ispali("perica reže raci rep"))             --> false   (unsupported UTF8 string)
print(ispali("edo suče meč usode."))              --> false   (unsupported UTF8 string)
print(ispali("this is not palindrome"))           --> false
