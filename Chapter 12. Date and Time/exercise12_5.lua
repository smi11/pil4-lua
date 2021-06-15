--[=[

  Exercise 12.5: Write a function that computes the number of complete days
  between two given dates.

--]=]

local function daydiff(ts1, ts2)

  if ts2<ts1 then
    ts1, ts2 = ts2, ts1 -- make sure ts1 is before ts2
  end

  local date1=os.date("*t",ts1)
  local date2=os.date("*t",ts2)

  date1.day=date1.day+1 -- move date1 to next day at 00:00:00
  date1.hour=0
  date1.min=0
  date1.sec=0

  date2.hour=0          -- move date2 to beginning of its day
  date2.min=0
  date2.sec=0

  -- now the difference of those two dates is in full days
  -- for some reason os.difftime returns float, so we'll force it to integer
  -- and divide it by number of seconds per day to get full days
  return math.tointeger(os.difftime(os.time(date2), os.time(date1))) // (24*3600)
end

print(daydiff(os.time{year=2021, month=3, day=1, hour=1, min=30,sec=0},
              os.time{year=2021, month=3, day=3, hour=18, min=30,sec=0}))
--> 1


print(daydiff(os.time{year=2021, month=3, day=1, hour=1, min=0,sec=0},
              os.time{year=2020, month=3, day=1, hour=1, min=0,sec=0}))
--> 364
