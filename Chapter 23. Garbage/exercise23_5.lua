--[=[

  Exercise 23.5: For this exercise, you need at least one Lua script that uses
  lots of memory. If you do not have one, write it. (It can be as simple as a
  loop creating tables.)

  • Run your script with different values for pause and stepmul. How they affect
    the performance and memory usage of the script? What happens if you set the
    pause to zero? What happens if you set the pause to 1000? What happens if
    you set the step multiplier to zero? What happens if you set the step
    multiplier to 1000000?

  • Adapt your script so that it keeps full control over the garbage collector.
    It should keep the collector stopped and call it from time to time to do
    some work. Can you improve the performance of your script with this
    approach?

--]=]

local defstep, defpause = 200, 100

-- count every GC cycle

local GCcycles = 0
do
  local mt = {__gc = function (o)
    GCcycles = GCcycles + 1
    setmetatable({}, getmetatable(o))
  end}
  setmetatable({}, mt)
end

-- first test using defaults

print("default  ", GCcycles, collectgarbage("count"))

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> default   0 28.3232421875
--> 0.050731  4 7543.77734375
--> -----

-- pause 0 test

print("pause 0  ", GCcycles, collectgarbage("count"))
collectgarbage("setpause", 0)

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> pause 0   0 26.54296875
--> 0.146029  54  7543.83203125
--> -----

-- pause 1000 test

print("pause 1000", GCcycles, collectgarbage("count"))
collectgarbage("setpause", 1000)

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> pause 1000  1 27.39453125
--> 0.030063  6 7543.70703125
--> -----

-- stepmul 0 test

print("stepm 0  ", GCcycles, collectgarbage("count"))
collectgarbage("setstepmul", 0)

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> stepm 0   0 26.62109375
--> 0.030071  1 7543.70703125
--> -----

-- stepmul 100000 test

print("stepm 100000", GCcycles, collectgarbage("count"))
collectgarbage("setstepmul", 100000)

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> stepm 100000  0 26.65234375
--> 4.323231  6188  7543.77734375
--> -----

------------------------------------------

--[[

* How they affect the performance and memory usage of the script?

Both parameters affect how often garbage collector is called and how much
work it does. Therefore depending on our job we can "fine-tune" GC to
that specific task.

* What happens if you set the pause to zero?

With setpause set to 0 GC will be called constantly therefore keeping memory
usage to minimum but wasting CPU time. For my table creation loop GC was called
54 times and running time tripled.

* What happens if you set the pause to 1000?

With setpause set to 1000 performance improved slightly even though GC was
called slightly more often than with default settings.

* What happens if you set the step multiplier to zero?

With setstepmul set to 0, GC was called only once and performance was the
best of all other tests.

* What happens if you set the step multiplier to 1000000?

GC was called about 6188 times and that also reflected on the time the script
ran which was almost four and a half seconds on my low-end machine.

--]]

-- controlling GC1

print("user GC1  ", GCcycles, collectgarbage("count"))
collectgarbage("stop")

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
  if i % 50000 == 0 then collectgarbage("step", 10) end
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> user GC1    0 28.3330078125
--> 0.030064  0 7545.224609375
--> -----

-- controlling GC2

print("user GC2  ", GCcycles, collectgarbage("count"))
collectgarbage("stop")

local time = os.clock()
local a = {}

for i = 1, 100000 do
  a[i] = {}
end

time = os.clock() - time

print(time, GCcycles, collectgarbage("count"))

a = nil
collectgarbage()
collectgarbage("setstepmul", defstep)  -- back to default
collectgarbage("setpause", defpause) -- back to default
GCcycles = 0

print("-----")
--> user GC2    0 28.3330078125
--> 0.025766  0 7545.224609375
--> -----

--[[

* Can you improve the performance of your script with this approach?

Approach by stopping GC and controlling in manually would work great for
some other script. For this tiny loop the best option is to simply stop
GC for the entire loop and resume it afterwards.

--]]
