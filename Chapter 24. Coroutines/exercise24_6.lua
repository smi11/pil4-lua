--[=[

  Exercise 24.6: Implement a transfer function in Lua. If you think about
  resume–yield as similar to call–return, a transfer would be like a goto: it
  suspends the running coroutine and resumes any other coroutine, given as an
  argument. (Hint: use a kind of dispatch to control your coroutines. Then, a
  transfer would yield to the dispatch signaling the next coroutine to run, and
  the dispatch would resume that next coroutine.)

--]=]

local function transfer(co)
  coroutine.yield(co)
end

local co1, co2, co3

co1 = coroutine.create(
  function ()
    print("co1 - enter")
    transfer(co1) -- back to self
    print("co1 - in")
    transfer(co2)
    print("co1 - done")
    transfer(co2)
  end)

co2 = coroutine.create(
  function ()
    print("co2 - enter")
    transfer(co1)
    print("co2 - in")
    transfer(co2) -- back to self, since co1 is already done
    print("co2 - done")
    transfer(co3) -- final jump to co3
  end)

co3 = coroutine.create(
  function ()
    print("co3 - Hello and goodbye")
  end)

local function dispatch(start)
  local stat, co = true, start
  repeat
    stat, co = coroutine.resume(co)
  until not stat or co == nil
end

dispatch(co1) -- start with co1
--> co1 - enter
--> co1 - in
--> co2 - enter
--> co1 - done
--> co2 - in
--> co2 - done
--> co3 - Hello and goodbye
