--[=[

  Exercise 8.5: Can you explain why Lua has the restriction that a goto cannot
  jump out of a function? (Hint: how would you implement that feature?)

  - Because if we jump to a different block with different variable scope we
    have a problem of how would we know the state of variables of this new
    block and/or scope.

    That's why there are actually three restrictions ragarding goto statement:

    1. First, labels follow the usual visibility rules, so we cannot jump into
       a block (because a label inside a block is not visible outside it).

    2. Second, we cannot jump out of a function. (Note that the first rule
       already excludes the possibility of jumping into a function.)

    3. Third, we cannot jump into the scope of a local variable.
--]=]

