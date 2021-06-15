--[=[

  Exercise 21.4: A variation of the dual representation is to implement objects
  using proxies (the section called “Tracking table accesses”). Each object is
  represented by an empty proxy table. An internal table maps proxies to tables
  that carry the object state. This internal table is not accessible from the
  outside, but methods use it to translate their self parameters to the real
  tables where they operate. Implement the Account example using this approach
  and discuss its pros and cons.

--]=]

function hide (t)
  local proxy = {} -- proxy table for 't'

  -- create metatable for the proxy
  local mt = {
    __index = function (_, k)
      return t[k] -- access the original table
    end,

    __newindex = function (_, k, v)
      t[k] = v -- update original table
    end,

    __pairs = function ()
      return function (_, k)  -- iteration function
        return next(t, k)
      end
    end,

    __len = function () return #t end
  }

  setmetatable(proxy, mt)
  return proxy
end

Account = {balance = 0}

function Account:new (o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return hide (o) -- use proxy to hide our new Account object
end

function Account:deposit (v)
  self.balance = self.balance + v
end

function Account:withdraw (v)
  if v > self.balance then error"insufficient funds" end
  self.balance = self.balance - v
end

local a = Account:new()
a:deposit(100)
a:withdraw(99)
print(a.balance) --> 1
a:withdraw(2)    -- error
--> lua: exercise21_4.lua:53: insufficient funds
--> stack traceback:
-->         [C]: in function 'error'
-->         exercise21_4.lua:53: in method 'withdraw'
-->         exercise21_4.lua:61: in main chunk
-->         [C]: in ?

-- pros:
-- sort of privacy
-- since proxy's __index and __newindex method translate all reads and writes to 
-- our original table, we still see balance, for example
-- but we don't see methods deposit and withdraw sice they are hidden as metamethods

-- cons:
-- since we use function for __index and __newindex access is a bit slower
-- greater privacy would be achieved by keeping balance data out of Account table
