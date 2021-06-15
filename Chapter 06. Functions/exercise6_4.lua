--[=[

  Exercise 6.4: Write a function to shuffle a given list. Make sure that all
  permutations are equally probable.

--]=]

function shuffle(a)
  local newpos
  for i = 1, #a do                     -- assure that every element is shuffled
    newpos = math.random(#a)           -- pick new random position
    a[i], a[newpos] = a[newpos], a[i]  -- swap current element with element on newpos
  end
  return a
end

function plist(t)
  print(table.unpack(t))
end

-- set new random seed
math.randomseed( os.time() )

plist(shuffle{1,2})         --> 1       2
plist(shuffle{1,2})         --> 2       1
plist(shuffle{1,2})         --> 2       1
plist(shuffle{1,2,3,4,5})   --> 2       4       3       1       5
plist(shuffle{1,2,3,4,5})   --> 1       5       2       3       4
plist(shuffle{1,2,3,4,5})   --> 4       2       5       1       3
plist(shuffle{1,2,3,4,5})   --> 4       3       1       5       2
