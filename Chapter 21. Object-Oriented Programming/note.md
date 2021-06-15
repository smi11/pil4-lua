---
title: Programming in Lua Fourth Edition
author: Roberto Ierusalimschy
chapter: 21. Object-Oriented Programming
tags: [study, book, Lua, programming]
created: 2021-01-18
url: https://www.lua.org/pil/
---
# 21. Object-Oriented Programming

* A table in Lua is an object in more than one sense. Like objects, tables have a state. Like objects, tables have an identity (a self) that is independent of their values; specifically, two objects (tables) with the same value are different objects, whereas an object can have different values at different times. Like objects, tables have a life cycle that is independent of who created them or where they were created.

    ```
    Account = {balance = 0}
    function Account.withdraw (v)
      Account.balance = Account.balance - v
    end
    Account.withdraw(100.00)
    ```

* This definition creates a new function and stores it in field withdraw of the object Account.

    ```
    a, Account = Account, nil
    a.withdraw(100.00) -- ERROR!
    ```

* Our method would need an extra parameter with the value of the receiver.

    ```
    function Account.withdraw (self, v)
      self.balance = self.balance - v
    end
    ```

* With the use of a self parameter, we can use the same method for many objects.
* Lua also can hide this parameter, with the colon operator.

    ```
    function Account:withdraw (v)
      self.balance = self.balance - v
    end
    ```

## Classes

* Our objects have an identity, state, and operations on this state. They still lack a class system, inheritance, and privacy.
* Most object-oriented languages offer the concept of class, which works as a mold for the creation of objects.
* We can emulate classes in Lua following the lead from prototype-based languages like Self.
* Each object may have a prototype, which is a regular object where the first object looks up any operation that it does not know about.
* In Lua, we can implement prototypes using the idea of inheritance that we saw in the section called “The __index metamethod”.

    `setmetatable(A, {__index = B})`

* To create other accounts with behavior similar to Account, we arrange for these new objects to inherit their operations from Account, using the `__index` metamethod.

    ```
    local mt = {__index = Account}
    function Account.new (o)
      o = o or {} -- create table if user does not provide one
      setmetatable(o, mt)
      return o
    end
    ```

* After this code we create a new account and call a method on it, like this:

    ```
    a = Account.new{balance = 0}
    a:deposit(100.00)
    ```

* When we create the new account, a, it will have mt as its metatable.
* When we call `a:deposit(100.00)`, we are actually calling `a.deposit(a, 100.00)`
* Lua cannot find a "deposit" entry in the table a; hence, Lua looks into the `__index` entry of the metatable.

    `getmetatable(a).__index.deposit(a, 100.00)`

* The metatable of `a` is `mt`, and `mt.__index` is `Account`. Therefore, the previous expression evaluates to this one:

    `Account.deposit(a, 100.00)`

* Lua calls the original deposit function, but passing a as the self parameter. 
* So, the new account a inherited the function deposit from Account. By the same mechanism, it inherits all fields from Account.
* We can make two small improvements on this scheme. The first one is that we do not need to create a new table for the metatable role; instead, we can use the Account table itself for that purpose.
* The second one is that we can use the colon syntax for the new method, too.

    ```
    function Account:new (o)
      o = o or {}
      self.__index = self
      setmetatable(o, self)
      return o
    end
    ```

* Now, when we call `Account:new()`, the hidden parameter self gets Account as its value, we make `Account.__index` also equal to Account, and set Account as the metatable for the new object.
* The inheritance works not only for methods, but also for other fields that are absent in the new account.
* A class can provide not only methods, but also constants and default values for its instance fields.

## Inheritance

* Because classes are objects, they can get methods from other classes, too.
* see Figure 21.1. the Account class

    `SpecialAccount = Account:new()`

* Up to now, SpecialAccount is just an instance of Account. The magic happens now:

    `s = SpecialAccount:new{limit=1000.00}`

* SpecialAccount inherits `new` from Account, like any other method. This time, however, when new executes, its self parameter will refer to SpecialAccount.
* What makes a SpecialAccount special is that we can redefine any method inherited from its superclass.

    ```
    function SpecialAccount:withdraw (v)
      if v - self.balance >= self:getLimit() then
        error"insufficient funds"
      end
      self.balance = self.balance - v
    end

    function SpecialAccount:getLimit ()
      return self.limit or 0
    end
    ```

## Multiple Inheritance

* Remember that, when a table's metatable has a function in the `__index` field, Lua will call this function whenever it cannot find a key in the original table. Then, `__index` can look up for the missing key in how many parents it wants.
* Multiple inheritance means that a class does not have a unique superclass.
* We will define an independent function for this purpose, createClass, which has as arguments all superclasses of the new class;
* see Figure 21.2. An implementation of multiple inheritance
* Assume our previous class Account and another class, Named, with only two methods: `setname` and `getname`.

    ```
    Named = {}
      function Named:getname ()
      return self.name
    end
    function Named:setname (n)
      self.name = n
    end
    ```

* To create a new class NamedAccount that is a subclass of both Account and Named, we simply call createClass:

    `NamedAccount = createClass(Account, Named)`

* To create and to use instances, we do as usual:

    ```
    account = NamedAccount:new{name = "Paul"}
    print(account:getname()) --> Paul
    ```

* Of course, due to the underlying complexity of this search, the performance of multiple inheritance is not the same as single inheritance. A simple way to improve this performance is to copy inherited methods into the subclasses:

    ```
    setmetatable(c, {__index = function (t, k)
      local v = search(k, parents)
      t[k] = v -- save for next access
      return v
    end})
    ```

* With this trick, accesses to inherited methods are as fast as to local methods, except for the first access. The drawback is that it is difficult to change method definitions after the program has started, because these changes do not propagate down the hierarchy chain.

## Privacy

* The standard implementation of objects in Lua, which we have shown previously, does not offer privacy mechanisms.
* If you do not want to access something that lives inside an object, just do not do it. A common practice is to mark all private names with an underscore at the end.
* Although the basic design for objects in Lua does not offer privacy mechanisms, we can implement objects in a different way, to have access control.
* The basic idea of this alternative design is to represent each object through two tables: one for its state and another for its operations, or its interface.
* To avoid unauthorized access, the table representing the state of an object is not kept in a field of the other table; instead, it is kept only in the closure of the
methods.

## The Single-Method Approach

* When an object has a single method, we do not need to create an interface table; instead, we can return this single method as the object representation.
*  If this sounds a little weird, it is worth remembering iterators like io.lines or string.gmatch. An iterator that keeps state internally is nothing more than a single-method object.
* Another interesting case of single-method objects occurs when this single-method is actually a dispatch method that performs different tasks based on a distinguished argument.

    ```
    function newObject (value)
      return function (action, v)
        if action == "get" then return value
        elseif action == "set" then value = v
        else error("invalid action")
        end
      end
    end
    d = newObject(0)
    print(d("get")) --> 0
    d("set", 10)
    print(d("get")) --> 10
    ```

* There is no inheritance, but we have full privacy: the only way to access an object state is through its sole method.
* Tcl/Tk uses a similar approach for its widgets.

## Dual Representation

* Another interesting approach for privacy uses a dual representation.

    `table[key] = value`

* We can use a table to represent a key, and use the object itself as a key in that table:

    ```
    key = {}
    ...
    key[table] = value
    ```

* As an example, in our Account implementation, we could keep the balances of all accounts in a table balance, instead of keeping them in the accounts themselves. Our withdraw method would become like this:

    ```
    function Account.withdraw (self, v)
      balance[self] = balance[self] - v
    end
    ```

* What we gain here? Privacy. Even if a function has access to an account, it cannot directly access its balance unless it also has access to the table balance. If the table balance is kept in a local inside the module Account, only functions inside the module can access it and, therefore, only those functions can manipulate account balances.
* There is a big naivety of this implementation.
* Once we use an account as a key in the balance table, that account will never become garbage for the garbage collector.
