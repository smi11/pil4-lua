function printResult (a)
  for i = 1, #a do io.write(a[i], " ") end
  io.write("\n")
end

-- Figure 24.2. A function to generate permutations

function permgen (a, n)
  n = n or #a -- default for 'n' is size of 'a'
  if n <= 1 then -- nothing to change?
    printResult(a)
  else
    for i = 1, n do
      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]
      -- generate all permutations of the other elements
      permgen(a, n - 1)
      -- restore i-th element
      a[n], a[i] = a[i], a[n]
    end
  end
end

permgen ({1,2,3,4})
