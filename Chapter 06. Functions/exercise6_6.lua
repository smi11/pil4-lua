--[=[

  Exercise 6.6: Sometimes, a language with proper-tail calls is called properly
  tail recursive, with the argument that this property is relevant only when
  we have recursive calls. (Without recursive calls, the maximum call depth of
  a program would be statically fixed.)

  Show that this argument does not hold in a dynamic language like Lua: write a
  program that performs an unbounded call chain without recursion. (Hint: see
  the section called “Compilation”.)

  - We can call function 'load' with a reader function as its first argument.
    A reader function can return the chunk in parts; load calls the reader
    successively until it returns nil, which signals the chunk's end.

    Therefore we can create an unbounded call chain using function load.

--]=]

-- Example of unbounded call chain that runs forever without exhausting stack
-- but it will exhaust memory eventually

function unbounded()
  i = (i or 0) + 1
  print(string.format("I'm called %i time-s. Stop me with Ctrl-C.",i))
  return ';' -- we are building a lua program entirely of statement separators
end

-- stop the programm by pressing Ctrl-C
load(unbounded)
