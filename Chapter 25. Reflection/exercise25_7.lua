--[=[

  Exercise 25.7: Write a library for breakpoints. It should offer at least two
  functions:

    setbreakpoint(function, line) --> returns handle
    removebreakpoint(handle)

  We specify a breakpoint by a function and a line inside that function. When
  the program hits a breakpoint, the library should call debug.debug. (Hint: for
  a basic implementation, use a line hook that checks whether it is in a
  breakpoint; to improve performance, use a call hook to trace program execution
  and only turn on the line hook when the program is running the target
  function.)

--]=]

local breakpoints = {}

function bphook(event, line)
  local f = debug.getinfo(2, "f").func

  -- we may enter a function with breakpoint through either "call" or "return" event

  if event == "call" then
    if breakpoints[f] then        -- in function with breakpoints
      line = line or debug.getinfo(2, "l").currentline

      if breakpoints[f][line] then   -- this line has breakpoint?
        print("Breakpoint: " .. debug.getinfo(2, "n").name .. ":" .. line)
        debug.debug()
      else
        debug.sethook(bphook, "lr")  -- trace all lines for this function
      end
    else
      debug.sethook(bphook, "cr")   -- resume "call" and "return" hook
    end

  elseif event == "return" then
    local fcaller = debug.getinfo(3, "f")
    if fcaller then fcaller = fcaller.func end -- fetch caller function if available

    if breakpoints[fcaller] then
      debug.sethook(bphook, "lr") -- return to function with breakpoints, resume "line" hook
    else
      debug.sethook(bphook, "cr") -- resume "call" and "return" hook
    end

  elseif event == "line" then -- and breakpoints[f][line]
    if breakpoints[f][line] then   -- this line has breakpoint?
      print("Breakpoint: " .. debug.getinfo(2, "n").name .. ":" .. line)
      debug.debug()
    end
  end
end

function setbreakpoint (func, line)
  assert(type(func) == "function", "Function expected as a first parameter")
  assert(type(line) == "number", "Line number expected as second parameter")

  breakpoints[func] = breakpoints[func] or {}
  breakpoints[func][line] = true
  debug.sethook(bphook, "c") -- start with "call" hook only
  return {func = func, line = line}
end

function removebreakpoint (handle)
  if handle then
    breakpoints[handle.func][handle.line] = nil -- remove breakpoint at that line

    if next(breakpoints[handle.func]) == nil then
      breakpoints[handle.func] = nil -- no more breakpoints in that function
    end
  end

  if next(breakpoints) == nil then
    debug.sethook() -- no more breakpoints so remove debug hook
  end
end

function test()
  a = 10
  print("variable a =", a)
  b = 20
  print("variable b =", b)
end

function test2()
  c = 30
  print("variable c =", c)
end

handle = setbreakpoint(test, 82)
removebreakpoint(handle)
setbreakpoint(test, 84)
setbreakpoint(test2, 89)

test()
--> variable a =    10
--> Breakpoint: test:84
--> lua_debug> cont

test2()
--> variable b =    20
--> Breakpoint: test2:89
--> lua_debug> cont
--> variable c =    30

print("done")
--> done
