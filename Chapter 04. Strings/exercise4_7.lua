--[[

  Exercise 4.7: Write a function to check whether a given string is a
  palindrome:

  > ispali("step on no pets") --> true
  > ispali("banana") --> false

--]]

function ispali(s)
  return s == string.reverse(s)
end

print(ispali("step on no pets"))  --> true
print(ispali("banana"))           --> false
