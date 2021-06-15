---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 12. Date and Time
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 12. Date and Time

* Lua uses two representations for date and time.
* The first one is through a single number, usually an integer. On most systems this number is the number of seconds since some fixed date, called the epoch. In particular, both in POSIX and Windows systems the epoch is Jan 01, 1970, 0:00 UTC. 
* The second representation that Lua uses for dates and times is a table. Such date tables have the following significant fields: year, month, day, hour, min, sec, wday, yday, and isdst.
* Date tables do not encode a time zone. It is up to the program to interpret them correctly with respect to time zones.

## The Function `os.time`

* The function `os.time`, when called without arguments, returns the current date and time, coded as a number.
* We can also call `os.time` with a date table, to convert the table representation to a number. The `year`, `month`, and `day` fields are mandatory. The `hour`, `min`, and `sec` fields default to noon (12:00:00) when not provided. Other fields (including `wday` and `yday`) are ignored.

## The Function `os.date`

* The function `os.date` converts a number representing the date and time to some higher-level representation, either a date table or a string.
* Its first parameter is a format string, describing the representation we want.
* The second parameter is the numeric date–time; it defaults to the current date and time if not provided.
* In general, we have that `os.time(os.date("*t", t)) == t`, for any valid time t.
* If the format string starts with an exclamation mark, then `os.date` interprets the time in UTC.

## Date–Time Manipulation

* When `os.date` creates a date table, its fields are all in the proper ranges. However, when we give a date table to `os.time`, its fields do not need to be normalized. This feature is an important tool to manipulate dates and times.

```
t = os.date("*t")                       -- get current time
print(os.date("%Y/%m/%d", os.time(t)))  --> 2015/08/18
t.day = t.day + 40
print(os.date("%Y/%m/%d", os.time(t)))  --> 2015/09/27

t = os.date("*t")
print(t.day, t.month)                   --> 26 2
t.day = t.day - 40
print(t.day, t.month)                   --> -14 2
t = os.date("*t", os.time(t))
print(t.day, t.month)                   --> 17 1

t = os.date("*t")                       -- get current time
print(os.date("%Y/%m/%d", os.time(t)))  --> 2015/08/18
t.month = t.month + 6                   -- six months from now
print(os.date("%Y/%m/%d", os.time(t)))  --> 2016/02/18

local t5_3 = os.time({year=2015, month=1, day=12})
local t5_2 = os.time({year=2011, month=12, day=16})
local d = os.difftime(t5_3, t5_2)
print(d // (24 * 3600))                 --> 1123.0

local x = os.clock()
local s = 0
for i = 1, 100000 do s = s + i end
print(string.format("elapsed time: %.2f\n", os.clock() - x))
```
