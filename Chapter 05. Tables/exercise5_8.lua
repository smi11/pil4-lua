--[=[

  Exercise 5.8: The table library offers a function table.concat, which receives
  a list of strings and returns their concatenation:

  print(table.concat({"hello"," ", "world"})) --> hello world

  Write your own version for this function.

  Compare the performance of your implementation against the built-in version
  for large lists, with hundreds of thousands of entries. (You can use a for
  loop to create those large lists.)

--]=]

-- table concat function
function tconcat(t)
  local s = ""
  for i = 1, #t do
    s = s .. t[i]
  end
  return s
end

-- quick test
print(tconcat({"hello"," ", "world"})) --> hello world

-- build big table
t = {}

for i = 1,100000 do
  t[#t+1] = "hello"
  t[#t+1] = " "
  t[#t+1] = "world"
  t[#t+1] = ", "
end

-- time built-in table.concat function on big table
tstart = os.clock()
s = table.concat(t)
tend = os.clock() - tstart

print("built-in table.concat ", tend)

-- time our tconcat function on big table

tstart = os.clock()
s = tconcat(t)
tend = os.clock() - tstart

print("our slow tconcat", tend)
