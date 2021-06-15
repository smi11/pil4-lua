---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 17. Modules and Packages
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 17. Modules and Packages

* From the point of view of the user, a module is some code (either in Lua or in C) that can be loaded through the function require and that creates and returns a table.
* An obvious benefit of using tables to implement modules is that we can manipulate modules like any other table and use the whole power of Lua to create extra facilities.

```
local mod = require "mod"     -- usual way to require a module
mod.foo()

local m = require "mod"       -- using custom name
m.foo()

local m = require "mod"       -- alternative name for specific module function
local f = m.foo
f()

local f = require "mod".foo   -- require specific function
f()
```

## The Function `require`

* The first step of `require` is to check in the table package.loaded whether the module is already loaded. If so, require returns its corresponding value. Therefore, once a module is loaded, other calls requiring the same module simply return the same value, without running any code again.
* If the module is not loaded yet, `require` searches for a Lua file with the module name.
* If it finds such a file, it loads it with `loadfile`. The result is a function that we call a loader.
* If require cannot find a Lua file with the module name, it searches for a C library with that name.
* If it finds a C library, it loads it with the low-level function `package.loadlib`, looking for a function called `luaopen_modname`.
* To finally load the module, `require` calls the loader with two arguments: the module name and the name of the file where it got the loader.
*  If the loader returns any value, `require` returns this value and stores it in the `package.loaded` table, to return the same value in future calls for this same module.
* To force `require` into loading the same module twice, we can erase the library entry from `package.loaded`:

    `package.loaded.modname = nil`

* Modules do not support parameters. Eg. degrees or radians for math functions.
* In case you really want your module to have parameters, it is better to create an explicit function to set them:

```
local mod = require "mod"
mod.init(0, 0)

-- If the initialization function returns the module itself, we can write that code like this:

local mod = require "mod".init(0, 0)
```

## Renaming a module

* Lua modules do not have their names fixed internally, so usually it is enough to
rename the .lua file.
* We cannot do that with C library.
* However if the C module name contains a hyphen, `require` strips from the name its suffix after the hyphen when creating the `luaopen_*` function name.
* For instance, if a module is named `mod-v3.4`, `require` expects its open
function to be named `luaopen_mod`, instead of `luaopen_mod-v3.4`.

## Path searching
## Searchers
## The Basic Approach for Writing Modules in Lua
## Submodules and Packages
