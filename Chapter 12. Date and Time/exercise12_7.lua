--[=[

  Exercise 12.7: Does adding one month and then one day to a given date give the
  same result as adding one day and then one month?

  - No, it does not. The problem comes with dates that are end of shorter month.

--]=]

local function testdate(ts)
  t = os.date("*t",ts)
  print("datetime",os.date("%c", os.time(t)))
  t.month = t.month + 1             -- add 1 month
  t = os.date("*t", os.time(t))     -- normalize t
  print("+1 month", os.date("%c", os.time(t)))
  t.day = t.day + 1                 -- add 1 day
  t = os.date("*t", os.time(t))     -- normalize t
  print("+1 day  ", os.date("%c", os.time(t)))

  t = os.date("*t",ts)
  print("datetime",os.date("%c", os.time(t)))
  t.day = t.day + 1                 -- add 1 day
  t = os.date("*t", os.time(t))     -- normalize t
  print("+1 day  ", os.date("%c", os.time(t)))
  t.month = t.month + 1             -- add 1 month
  t = os.date("*t", os.time(t))     -- normalize t
  print("+1 month", os.date("%c", os.time(t)))
end

testdate(os.time{year=2021,month=3,day=4})
--> datetime        Thu Mar  4 12:00:00 2021
--> +1 month        Sun Apr  4 13:00:00 2021
--> +1 day          Mon Apr  5 13:00:00 2021
--> datetime        Thu Mar  4 12:00:00 2021
--> +1 day          Fri Mar  5 12:00:00 2021
--> +1 month        Mon Apr  5 13:00:00 2021

testdate(os.time{year=2021,month=2,day=28})
--> datetime        Sun Feb 28 12:00:00 2021
--> +1 month        Sun Mar 28 13:00:00 2021
--> +1 day          Mon Mar 29 13:00:00 2021
--> datetime        Sun Feb 28 12:00:00 2021
--> +1 day          Mon Mar  1 12:00:00 2021
--> +1 month        Thu Apr  1 13:00:00 2021
