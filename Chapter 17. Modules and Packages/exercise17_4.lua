--[=[

  Exercise 17.4: Write a searcher that searches for Lua files and C libraries at
  the same time. For instance, the path used for this searcher could be
  something like this:

    ./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua

  (Hint: use package.searchpath to find a proper file and then try to load it,
  first with loadfile and next with package.loadlib.)

--]=]

function lua_c_searcher(name, path)
  local file, err = package.searchpath(name, path)
  if not file then
    return nil, "Module not found "..err
  end
  local func = loadfile(file)
  if func then
    return func
  end
  func = package.loadlib(file, "main")
  if func then
    return func
  end
  return nil, "Unable to load "..name
end

-- search for C module foo.so
local f = assert(lua_c_searcher("foo", "./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua"))
f()
--> C module foo.so

-- search for lua module bar.lua
local f = assert(lua_c_searcher("bar", "./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua"))
f()
--> Lua module bar.lua

-- search for non-existant module baz
local f = assert(lua_c_searcher("baz", "./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua"))
--> lua: exercise17_4.lua:41: Module not found 
-->   no file './baz.lua'
-->   no file './baz.so'
-->   no file '/usr/lib/lua5.2/baz.so'
-->   no file '/usr/share/lua5.2/baz.lua'
--> stack traceback:
-->   [C]: in function 'assert'
-->   exercise17_4.lua:41: in main chunk
-->   [C]: in ?
f()
