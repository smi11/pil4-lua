--[=[

  Exercise 12.8: Write a function that produces the system's time zone.

--]=]

-- what is system's time zone offset in seconds?
local function systemtz()
  local ts = os.time()
  local utcdt   = os.date("!*t", ts) -- get utc datetime
  local localdt = os.date("*t", ts)  -- get local datetime
  localdt.isdst = false              -- ignore daylight savings flag
  -- os.difftime returns float, so use math.floor to convert back to integer
  return math.floor(os.difftime(os.time(localdt), os.time(utcdt)))
end

print(systemtz())
--> 3600 (in seconds = 1 hour)
