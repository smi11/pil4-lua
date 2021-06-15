--[=[

  Exercise 18.3: Write an iterator uniquewords that returns all words from a
  given file without repetitions. (Hint: start with the allwords code in Figure
  18.1, “Iterator to traverse all words from the standard input”; use a table to
  keep all words already reported.)

--]=]

function uniquewords(filename)
  local file = assert(io.open(filename,"r"))
  local line = file:read()  -- current line
  local pos = 1             -- current position in the line
  local reported = {}       -- already reported words
  return function ()        -- iterator function
    while line do
      local w, e = string.match(line, "(%w+)()", pos)
      if w then             -- found a word?
        pos = e
        w = string.lower(w)       -- ignore character case
        if not reported[w] then
          reported[w] = true
          return w            -- return the word
        end
      else
        line = file:read()  -- word not found; try next line
        pos = 1             -- restart from first position
      end
    end
    file:close()            -- close file (assuming break is not used while iterating)
    return nil              -- no more lines: end of traversal
  end
end

for word in uniquewords("words.txt") do
  print(word)
end
--> keeping
--> time
--> in
--> a
--> sort
--> of
--> runic
--> rhyme
--> to
--> the
--> pean
--> bells
--> throbbing
--> sobbing
--> as
--> he
--> knells
--> happy
--> rolling
--> tolling
--> moaning
--> and
--> groaning
