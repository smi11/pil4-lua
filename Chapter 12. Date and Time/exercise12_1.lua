--[=[

  Exercise 12.1: Write a function that returns the date–time exactly one month
  after a given date–time. (Assume the numeric coding of date–time.)

--]=]

local function addmonth(ts)
  local date = os.date("*t",ts)
  date.month = date.month + 1
  return os.time(date)
end

print(os.date("%c",addmonth(os.time{year=2021, month=3, day=1})))
--> Sat Apr  1 13:00:00 2021

print(os.date("%c",addmonth(os.time{year=2021, month=3, day=30})))
--> Sat Apr 30 12:00:00 2021

print(os.date("%c",addmonth(os.time{year=2021, month=3, day=31})))
--> Sat May  1 12:00:00 2021
