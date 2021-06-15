#!/usr/bin/env lua

--[=[

  Exercise 7.6: Using os.execute and io.popen, write functions to create a
  directory, to remove a directory, and to collect the entries in a directory.

--]=]

function createDir (dirname)
  return os.execute("mkdir " .. dirname)
end

function removeDir (dirname)
  return os.execute("rmdir " .. dirname)
end

local function readDir(path)
  local f = io.popen("ls -1 " .. path, "r")
  local dir = {}
  for entry in f:lines() do
    dir[#dir + 1] = entry
  end
  return dir
end

createDir("hello")
removeDir("hello")
local a = readDir(".")

for i,v in ipairs(a) do
  print(v)
end
