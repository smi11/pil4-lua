--[=[

  Exercise 11.1: When we apply the word-frequency program to a text, usually the
  most frequent words are uninteresting small words like articles and
  prepositions. Change the program so that it ignores words with less than four
  letters.

--]=]

local counter = {}

for line in io.lines() do
  for word in string.gmatch(line, "%w+") do
    if #word > 3 then                           -- we just add appropriate condition
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
