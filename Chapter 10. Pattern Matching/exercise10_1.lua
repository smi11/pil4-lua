--[=[

  Exercise 10.1: Write a function split that receives a string and a delimiter
  pattern and returns a sequence with the chunks in the original string
  separated by the delimiter:

  t = split("a whole new world", " ")
  -- t = {"a", "whole", "new", "world"}

  How does your function handle empty strings? (In particular, is an empty
  string an empty sequence or a sequence with one empty string?)

--]=]

function split(str, sep)
  sep = sep or "%s"  -- default class with space characters
  local t={}
  for s in string.gmatch(str, "([^"..sep.."]+)") do
    t[#t+1] = s
  end
  return t
end

local t = split("a whole new world", " ")
print(table.unpack(t))
--> a   whole  new  world

local t = split("")
print(table.unpack(t))
--> (empty sequence t)

local t = split("  a")
print(table.unpack(t))
--> a

local t = split("a/whole/new/world", "/")
print(table.unpack(t))
--> a   whole  new  world

local t = split("a    whole    new    world")
print(table.unpack(t))
--> a   whole  new  world
