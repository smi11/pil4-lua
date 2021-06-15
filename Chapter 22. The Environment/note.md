---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 22. The Environment
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 22. The Environment

* Lua keeps all its global variables in a regular table, called the global environment
* Lua can keep its “global” variables in several environments
* Lua stores the global environment itself in the global variable `_G`.

## Global Variables with Dynamic Names

* when we need to manipulate a global variable whose name is stored in another variable or is somehow computed at run time, we can use:

    `value = _G[varname]`

* If we write `_G["io.read"]`, clearly we will not get the field read from the table io.

    ```
    function getfield (f)
      local v = _G -- start with the table of globals
      for w in string.gmatch(f, "[%a_][%w_]*") do
        v = v[w]
      end
      return v
    end
    ```

* See setfield.lua

    ```
    setfield("t.x.y", 10)
    print(t.x.y) --> 10
    print(getfield("t.x.y")) --> 10
    ```

## Global-Variable Declarations

* Global variables in Lua do not need declarations.
* We can use metatables to detect when Lua accesses non-existent variables
* The Lua distribution comes with a module strict.lua that implements a global-variable check that uses essentially the code in Figure 22.2, “Checking global-variable declaration”.

## Non-Global Environments

* A free name is a name that is not bound to an explicit declaration, that is, it does not occur inside the scope of a corresponding local variable.

    ```
    local z = 10
    x = y + z
    ```

* x and y are free names, z is not
* The Lua compiler translates any free name x in the chunk to _ENV.x

    ```
    local z = 10
    _ENV.x = _ENV.y + z
    ```

* `_ENV` cannot be a global variable; we just said that Lua has no global variables.
* Lua compiles our original chunk as the following code:

    ```
    local _ENV = some value
    return function (...)
      local z = 10
      _ENV.x = _ENV.y + z
    end
    ```

* The compiler creates a local variable `_ENV` outside any chunk that it compiles.
* The compiler translates any free name var to `_ENV.var`.
* The function `load` (or `loadfile`) initializes the first upvalue of a chunk with the global environment, which is a regular table kept internally by Lua.
* `_ENV` only applies to Lua 5.2+, Lua 5.1 had different mechanism

## Using _ENV

* Because `_ENV` is a regular variable, we can assign to and access it as any other variable.
* The assignment `_ENV = nil` will invalidate any direct access to global variables in the rest of the chunk.
* Usually, `_G` and `_ENV` refer to the same table but, despite that, they are quite different entities. `_ENV` is a local variable, and all accesses to “global variables” in reality are accesses to it. `_G` is a global variable with no special status whatsoever. By definition, `_ENV` always refers to the current environment; `_G` usually refers to the global environment, provided it is visible and no one changed its value.
* The main use for `_ENV` is to change the environment used by a piece of code. Once we change the environment, all global accesses will use the new table:

    ```
    -- change current environment to a new empty table
    _ENV = {}
    a = 1 -- create a field in _ENV
    print(a)
    --> stdin:4: attempt to call global 'print' (a nil value)
    ```

## Environments and Modules

* We can declare all public functions as global variables and they will go to a separate table automatically. All the module has to do is to assign this table to the `_ENV` variable. After that, when we declare a function `add`, it goes to `M.add`:

    ```
    local M = {}
    _ENV = M
    function add (c1, c2)
      return new(c1.r + c2.r, c1.i + c2.i)
    end
    ```

* Nevertheless, currently I still prefer the original basic method. It may need more work, but the resulting code states clearly what it does. To avoid creating a global by mistake, I use the simple method of assigning nil to `_ENV`.

## `_ENV` and `load`

* `load` usually initializes the `_ENV` upvalue of a loaded chunk with the global environment. However, load has an optional fourth parameter that allows us to give a different initial value for `_ENV`.

    ```
    env = {}
    loadfile("config.lua", "t", env)()
    ```

* The whole code in the configuration file will run in the empty environment env, which works as a kind of sandbox.
* Sometimes, we may want to run a chunk several times, each time with a different environment table. In that case, the extra argument to load is not useful. Instead, we have two other options.

1. use the function `debug.setupvalue`, from the debug library

    ```
    f = load("b = 10; return a")
    env = {a = 20}
    debug.setupvalue(f, 1, env)
    print(f()) --> 20
    print(env.b) --> 10
    ```

2. Lua compiles any chunk as a variadic function. So, we can add prefix `_ENV = ...;` thereby setting first argument of that function as the environment.

    ```
    prefix = "_ENV = ...;"
    f = loadwithprefix(prefix, io.lines(filename, "*L"))
    ...
    env1 = {}
    f(env1)
    env2 = {}
    f(env2)
    ```
