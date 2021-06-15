--[=[

  Exercise 12.3: Write a function that takes a date–time (coded as a number) and
  returns the number of seconds passed since the beginning of its respective
  day.

--]=]

local function secondsofday(ts)
  local date = os.date("*t", ts)
  return date.sec + date.min * 60 + date.hour * 3600
end

print(secondsofday(os.time{year=2021, month=3, day=1, hour=18, min=30,sec=0}))
--> 66600

print(secondsofday(os.time{year=2021, month=3, day=1, hour=18, min=0,sec=0}))
--> 64800

print(secondsofday(os.time{year=2021, month=3, day=1, hour=18, min=0,sec=1}))
--> 64801

print(secondsofday(os.time{year=2021, month=3, day=1, hour=0, min=0,sec=0}))
--> 0
