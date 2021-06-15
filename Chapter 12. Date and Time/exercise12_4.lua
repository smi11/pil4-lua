--[=[

  Exercise 12.4: Write a function that takes a year and returns the day of its
  first Friday.

--]=]

local function firstfriday(year)
  local date=os.date("*t",os.time{year=year,month=1,day=1})
  if date.wday <= 6 then              -- 6 = Friday
    date.day = date.day+(6-date.wday) -- if Sun to Fri just add difference of wday
  else
    date.day = date.day+6             -- if Sat add 6 days for next Friday
  end
  return os.time(date)
end

for year=1990, 2021 do
  print(os.date("%c",firstfriday(year)))
end

--> Fri Jan  5 12:00:00 1990
--> Fri Jan  4 12:00:00 1991
--> Fri Jan  3 12:00:00 1992
--> Fri Jan  1 12:00:00 1993
--> Fri Jan  7 12:00:00 1994
--> Fri Jan  6 12:00:00 1995
--> Fri Jan  5 12:00:00 1996
--> Fri Jan  3 12:00:00 1997
--> Fri Jan  2 12:00:00 1998
--> Fri Jan  1 12:00:00 1999
--> Fri Jan  7 12:00:00 2000
--> Fri Jan  5 12:00:00 2001
--> Fri Jan  4 12:00:00 2002
--> Fri Jan  3 12:00:00 2003
--> Fri Jan  2 12:00:00 2004
--> Fri Jan  7 12:00:00 2005
--> Fri Jan  6 12:00:00 2006
--> Fri Jan  5 12:00:00 2007
--> Fri Jan  4 12:00:00 2008
--> Fri Jan  2 12:00:00 2009
--> Fri Jan  1 12:00:00 2010
--> Fri Jan  7 12:00:00 2011
--> Fri Jan  6 12:00:00 2012
--> Fri Jan  4 12:00:00 2013
--> Fri Jan  3 12:00:00 2014
--> Fri Jan  2 12:00:00 2015
--> Fri Jan  1 12:00:00 2016
--> Fri Jan  6 12:00:00 2017
--> Fri Jan  5 12:00:00 2018
--> Fri Jan  4 12:00:00 2019
--> Fri Jan  3 12:00:00 2020
--> Fri Jan  1 12:00:00 2021
