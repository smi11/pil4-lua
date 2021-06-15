--[=[

  Exercise 22.2: Explain in detail what happens in the following program and
  what it will print.

    local foo
    do
      local _ENV = _ENV
      function foo () print(X) end
    end
    X = 13
    _ENV = nil
    foo()
    X = 0

--]=]

local foo                       -- forward declaration of foo as local
do                              -- new variable scope
  local _ENV = _ENV             -- set local _ENV of do end block to global _ENV
  function foo () print(X) end  -- local function foo, printing _ENV.X 
end
X = 13                          -- set _ENV.X which is same as _G.X
_ENV = nil                      -- remove global environment
foo()                           -- call local foo which will print still valid X which is 13
X = 0                           -- unable to set _ENV.X as _ENV is nil so report error
