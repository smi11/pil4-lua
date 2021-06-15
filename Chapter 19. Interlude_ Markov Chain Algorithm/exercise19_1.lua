--[=[

  Exercise 19.1: Generalize the Markov-chain algorithm so that it can use any
  size for the sequence of previous words used in the choice of the next word.

  test with:

    $ lua exercise19_1.lua < test.md

--]=]

-- Figure 19.1. Auxiliary definitions for the Markov program

function allwords ()
  local line = io.read()  -- current line
  local pos = 1           -- current position in the line
  return function ()      -- iterator function
    while line do         -- repeat while there are lines
      local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
      if w then           -- found a word?
        pos = e           -- update next position
        return w          -- return the word
      else
        line = io.read()  -- word not found; try next line
        pos = 1           -- restart from first position
      end
    end
    return nil            -- no more lines: end of traversal
    end
end

-- instead of two variables with two words we concat a list of words
function prefix (t)
  return table.concat(t, " ")
end

local statetab = {}

function insert (prefix, value)
  local list = statetab[prefix]
  if list == nil then
    statetab[prefix] = {value}
  else
    list[#list + 1] = value
  end
end

-- Figure 19.2. The Markov program

local MAXGEN = 200
local NOWORD = "\n"
local WORDS  = 4   -- number of words to use for prefix

math.randomseed(os.time()) -- make sure every run is unique

wordlist = {} -- list of words for prefix

-- build table
for i = 1, WORDS do
  wordlist[i] = NOWORD
end

for nextword in allwords() do
  insert(prefix(wordlist), nextword)
  for i = 1, WORDS - 1 do
    wordlist[i] = wordlist[i+1]
  end
  wordlist[WORDS] = nextword
end

insert(prefix(wordlist), NOWORD)

-- generate text
for i = 1, WORDS do
  wordlist[i] = NOWORD
end

for i = 1, MAXGEN do
  local list = statetab[prefix(wordlist)]
  -- choose a random item from list
  local r = math.random(#list)
  local nextword = list[r]
  if nextword == NOWORD then return end
  io.write(nextword, " ")
  for i = 1, WORDS - 1 do
    wordlist[i] = wordlist[i+1]
  end
  wordlist[WORDS] = nextword
end

io.write("\n")
