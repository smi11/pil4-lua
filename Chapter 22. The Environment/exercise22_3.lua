--[=[

  Exercise 22.3: Explain in detail what happens in the following program and
  what it will print.

    local print = print
    function foo (_ENV, a)
      print(a + b)
    end
    foo({b = 14}, 12)
    foo({b = 10}, 1)

--]=]

local print = print       -- set local print to _G.print
                          -- without this declaration print inside foo would be nil

function foo (_ENV, a)    -- define function with private environment _ENV
  print(a + b)            -- print local a + _ENV.b
end
foo({b = 14}, 12)         -- call foo with _ENV.b = 14 and a = 12 --> 26
foo({b = 10}, 1)          -- call foo with _ENV.b = 10 and a = 1  --> 1
