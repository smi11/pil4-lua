--[[

  Exercise 2.2: An alternative implementation for the eight-queen problem would be
  to generate all possible permutations of 1 to 8 and, for each permutation, to
  check whether it is valid. Change the program to use this approach. How does the
  performance of the new program compare with the old one? (Hint: compare the total
  number of permutations with the number of times that the original program calls
  the function isplaceok.)

  - Looping over all permutations either non-recursively or with recursion is
    much slower than original solution. All three algorithms found 92 solutions
    for the queens problem.

    Original algorithm called isplaceok() 15720 times. Both non-recursive and
    recursive algorithm called isplaceok() 34112320 times and was significantly
    slower.

    Original algorithm abandons unnecessary tests (calls to isplaceok()) as soon
    as it encounters first invalid position of queens in that particular permutation.
    That saves a lot of unnecessary calls to isplaceok() and speeds up the search
    for solutions.

--]]

N = 8 -- board size

local solutions = 0  -- we'll do some counting to compare different algorithms
local tests = 0

-- check whether position (n,c) is free from attacks
function isplaceok (a, n, c)
  tests = tests + 1                 -- count how many times we called isplaceok
  for i = 1, n - 1 do             -- for each queen already placed
    if (a[i] == c) or             -- same column?
       (a[i] - i == c - n) or     -- same diagonal?
       (a[i] + i == c + n) then   -- same diagonal?
      return false  -- place can be attacked
    end
  end
  return true       -- no attacks; place is OK
end

-- print a board
function printsolution (a)
  -- do return end   -- uncomment this line to skip printing solutions
  for i = 1, N do -- for each row
    for j = 1, N do -- and for each column
      -- write "X" or "-" plus a space
      io.write(a[i] == j and "X" or "-", " ")
    end
    io.write("\n")
  end
  io.write("\n")
end

-- add to board 'a' all queens from 'n' to 'N'
function addqueen_original (a, n)
  if n > N then -- all queens have been placed?
    printsolution(a)
    solutions = solutions + 1 -- count solutions
  else -- try to place n-th queen
    for c = 1, N do
      if isplaceok(a, n, c) then
        a[n] = c -- place n-th queen at column 'c'
        addqueen_original(a, n + 1)
      end
    end
  end
end

-- non-recursive all permutations
local function allsolutions (a)
  -- generate all possible permutations
  for c1 = 1, N do
    a[1] = c1
    for c2 = 1, N do
      a[2] = c2
      for c3 = 1, N do
        a[3] = c3
        for c4 = 1, N do
          a[4] = c4
          for c5 = 1, N do
            a[5] = c5
            for c6 = 1, N do
              a[6] = c6
              for c7 = 1, N do
                a[7] = c7
                for c8 = 1, N do
                  a[8] = c8
                  -- validate the permutation
                  local valid
                  for r = 2, N do  -- start from 2nd row
                    valid = isplaceok(a, r, a[r])
                    if not valid then break end
                  end
                  if valid then
                    printsolution(a)
                    solutions = solutions + 1
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

-- Recursive all permutations
local function addqueen_perm (a, n)
  n = n or 1
  if n > N then
    -- verify the permutation
    local valid
    for r = 2, N do  -- start from 2nd row
      valid = isplaceok(a, r, a[r])
      if not valid then break end
    end
    if valid then
      printsolution(a)
      solutions = solutions + 1
    end
  else
    -- generate all possible permutations
    for c = 1, N do
      a[n] = c
      addqueen_perm(a, n + 1)
    end
  end
end

-- run the program
addqueen_original({}, 1)

-- report statistics
print("Original recursive search")
print(string.format("Solutions = %i, number of calls isplaceok() = %i\n", solutions, tests))

-- reset counters
solutions = 0
tests = 0

-- run non-recursive loop with all permutations
allsolutions({})

-- report statistics
print("Non-recursive search with loops over all permutations")
print(string.format("Solutions = %i, number of calls isplaceok() = %i\n", solutions, tests))

-- reset counters
solutions = 0
tests = 0

-- run recursive permutations
addqueen_perm({})

-- report statistics
print("Recursive search with all permutations")
print(string.format("Solutions = %i, number of calls isplaceok() = %i\n", solutions, tests))
