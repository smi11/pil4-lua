#!/usr/bin/env lua

--[=[

  Exercise 7.7: Can you use os.execute to change the current directory of your
  Lua script? Why?

  - No, you can't. os.execute is run in a child shell and it does change directory,
    but only in that child shell. Not in the parent/current shell. Therefore it is
    not possible to change current directory of your Lua script this way.

--]=]

