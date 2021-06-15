--[=[

  Exercise 12.6: Write a function that computes the number of complete months
  between two given dates.

--]=]

local function monthdiff(ts1, ts2)
  ts2 = ts2 or os.time() -- use now if ts2 not provided
  if ts2 < ts1 then
    ts1, ts2 = ts2, ts1 -- make sure ts1 is before ts2
  end
  local diff = os.date("*t",os.difftime(ts2, ts1))
  return (diff.year - 1970) * 12 + diff.month - 1 -- also subtract epoch 1970-01-01
end

print(monthdiff(os.time{year=2021, month=3, day=1},
                os.time{year=2021, month=3, day=3}))
--> 0

print(monthdiff(os.time{year=2021, month=3, day=1},  -- one month diff
                os.time{year=2021, month=4, day=1}))
--> 1

print(monthdiff(os.time{year=2021, month=3, day=1, sec=1},  -- a second short of month
                os.time{year=2021, month=4, day=1, sec=0}))
--> 0

print(monthdiff(os.time{year=2021, month=3, day=1},  -- a year diff
                os.time{year=2020, month=3, day=1}))
--> 12

print(monthdiff(os.time{year=1918, month=3, day=1},  -- 11 month diff before epoch
                os.time{year=1917, month=4, day=1}))
--> 11

print(monthdiff(os.time{year=1966, month=12, day=13})) -- months from today?
--> 650 (depends when you run this)
