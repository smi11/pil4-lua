--[[

  Exercise 4.5: Write a function to remove a slice from a string; the slice
  should be given by its initial position and its length:

  > remove("hello world", 7, 4) --> hello d

--]]

function remove(s,ofs,len)
  len = len or 1              -- if no len assume 1 character
  len = len < 0 and 0 or len  -- if negative len assume 0 characters
  if ofs < 0 then
    return table.concat{ string.sub(s,0,ofs-1), string.sub(s,ofs+len >= 0 and #s+1 or ofs+len) }
  else
    return table.concat{ string.sub(s,0,ofs-1), string.sub(s,ofs+len) }
  end
end

print(remove("hello world", 7, 4))       --> hello d
print(remove("hello world", 6, 6))       --> hello
print(remove("hello world", 6, 10))      --> hello
print(remove("hello world", 1, 6))       --> world
print(remove("hello world", 3, 2))       --> heo world
print(remove("hello world", 1))          --> ello world
print(remove("hello world", 1,-5))       --> hello world

-- negative index
print(remove("hello world", -1, 2))       --> hello worl
print(remove("hello world", -2, 2))       --> hello wor
print(remove("hello world", -9, 2))       --> heo world
