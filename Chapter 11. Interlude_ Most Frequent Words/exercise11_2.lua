--[=[

  Exercise 11.2: Repeat the previous exercise but, instead of using length as
  the criterion for ignoring a word, the program should read from a text file a
  list of words to be ignored.

--]=]

-- read file with words to ignore
-- each line contains one word to ignore while counting

local ignore = {} -- set of words to ignore

local f = assert(io.open("ignore.txt", "r"))

for word in f:lines() do
  ignore[word] = true
end

f:close()

local counter = {}

for line in io.lines() do
  for word in string.gmatch(line, "%w+") do
    if not ignore[word] then                   -- we just add appropriate condition
      counter[word] = (counter[word] or 0) + 1
    end
  end
end

local words = {} -- list of all words found in the text

for w in pairs(counter) do
  words[#words + 1] = w
end

table.sort(words, function (w1, w2)
                    return counter[w1] > counter[w2] or
                           counter[w1] == counter[w2] and w1 < w2
                  end)

-- number of words to print
local n = math.min(tonumber(arg[1]) or math.huge, #words)

for i = 1, n do
  io.write(words[i], "\t", counter[words[i]], "\n")
end
