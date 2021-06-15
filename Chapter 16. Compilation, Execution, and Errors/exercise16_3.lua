--[=[

  Exercise 16.3: The function stringrep, in Figure 16.2, “String repetition”,
  uses a binary multiplication algorithm to concatenate n copies of a given
  string s.

  Figure 16.2. String repetition

    function stringrep (s, n)
      local r = ""
      if n > 0 then
        while n > 1 do
          if n % 2 ~= 0 then r = r .. s end
          s = s .. s
          n = math.floor(n / 2)
        end
        r = r .. s
      end
      return r
    end

  For any fixed n, we can create a specialized version of stringrep by unrolling
  the loop into a sequence of instructions r = r .. s and s = s .. s. As an
  example, for n = 5 the unrolling gives us the following function:

    function stringrep_5 (s)
      local r = ""
      r = r .. s
      s = s .. s
      s = s .. s
      r = r .. s
      return r
    end

  Write a function that, given n, returns a specialized function stringrep_n.
  Instead of using a closure, your function should build the text of a Lua
  function with the proper sequence of instructions (a mix of r = r .. s and s =
  s .. s) and then use load to produce the final function. Compare the
  performance of the generic function stringrep (or of a closure using it) with
  your tailor-made functions.

--]=]


function stringrep (s, n)
  local r = ""
  if n > 0 then
    while n > 1 do
      if n % 2 ~= 0 then r = r .. s end
      s = s .. s
      n = math.floor(n / 2)
    end
    r = r .. s
  end
  return r
end

function stringrep_factory(n)
  local code = {
      "return function(s) ",
      "local r = '' ",
  }
  if n > 0 then
      while n > 1 do
          if n % 2 ~= 0 then
              code[#code+1] = "r=r..s "
          end
          code[#code+1] = "s=s..s "
          n = math.floor(n / 2)
      end
  end
  code[#code+1] = "r=r..s "
  code[#code+1] = "return r "
  code[#code+1] = "end"

  -- reader for load
  local index = 0
  local function reader()
      index = index + 1
      return code[index]
  end
  -- compile chunk and define it by executing it
  return assert(load(reader))()
end

-- tiny testing function
function test(name, amount, func, ...)
  local time = os.clock()
  for i = 1, amount do
      local r = func(...)
  end
  time = os.clock()-time
  print(name.." took "..time.." seconds to execute.")
end

local s = "this should be repeated "
local times = 300
local reps = 1000000
print(string.format("Timing stringrep(%q,%i) called %i times\n",s, times, reps))

-- run tests on string.rep
test("builtin string.rep", reps, string.rep, s, times)

-- run tests on stringrep
test("stringrep (PiL)", reps, stringrep, s, times)

-- run tests on stringrep_factory
test("stringrep_factory", reps, stringrep_factory(times), s)

--> Timing stringrep("this should be repeated ",300) called 1000000 times
--> 
--> builtin string.rep took 6.177 seconds to execute.
--> stringrep (PiL) took 6.287 seconds to execute.
--> stringrep_factory took 5.195 seconds to execute.

-- stringrep_factory seems to be fastest, however the time to build and compile 
-- stringrep_n function is not included in measurement.
-- I assume with that time included it would be closer to builtin string.rep function
-- Also, the higher the multiplication number is, all functions slow down quite a bit.
