--[[

  Exercise 4.3: Write a function to insert a string into a given position
  of another one:

  > insert("hello world", 1, "start: ") --> start: hello world
  > insert("hello world", 7, "small ") --> hello small world

--]]

function insert(s,ofs,ins)
  -- negative offset needs different calculation
  if ofs < 0 then
    -- right segment should be empty string if ofs is last character
    return table.concat{ string.sub(s,0,ofs), ins, ofs == -1 and "" or string.sub(s,ofs+1) }
  else
    return table.concat{ string.sub(s,0,ofs-1), ins, string.sub(s,ofs) }
  end
end

print(insert("hello world", 1, "start: "))            --> start: hello world
print(insert("hello world", 7, "small "))             --> hello small world

-- few extra with negative index
print(insert("hello world", -6, "even smaler "))      --> hello even smaler world
print(insert("hello world", -1, "!"))                 --> hello world!
print(insert("hello world", -7, ","))                 --> hello, world

print(insert("hello world", 6, ","))                  --> hello, world
