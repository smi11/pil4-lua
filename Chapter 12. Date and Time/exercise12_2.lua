--[=[

  Exercise 12.2: Write a function that returns the day of the week (coded as an
  integer, one is Sunday) of a given date.

--]=]

local function weekday(ts)
  local date = os.date("*t", ts)
  return date.wday
end

print(weekday(os.time{year=2021, month=3, day=1})) -- monday
--> 2

print(weekday(os.time{year=2021, month=3, day=2})) -- tuesday
--> 3

print(weekday(os.time{year=2021, month=3, day=6})) -- saturday
--> 7

print(weekday(os.time{year=2021, month=3, day=7})) -- sunday
--> 1
