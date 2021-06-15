--[=[

  Exercise 23.2: Consider the first example of the section called “Finalizers”,
  which creates a table with a finalizer that only prints a message when
  activated. What happens if the program ends without a collection cycle? What
  happens if the program calls os.exit? What happens if the program ends with an
  error?

--]=]

o = {x = "hi"}
setmetatable(o, {__gc = function (o) print(o.x) end})

--[=[ What happens if the program ends without a collection cycle?

-- Garbage is collected anyways and with that also finalizers are called.

--> hi

--]=]


--[=[ What happens if the program calls os.exit?

-- Program terminates without collecting garbage and calling finalizers

os.exit()

--]=]


--[=[ What happens if the program ends with an error?

error("Oops...")

-- Lua callects garbage and calls finalizers after displaying error message

--> hi

--]=]

-- only os.exit() skips garbage collection
