--[[

  Exercise 1.7: Consider the following expression:

      (x and y and (not z)) or ((not y) and x)

  Are the parentheses necessary? Would you recommend their use in that expression?


  - They are not necessary because operator 'not' has highest precedence,
    followed by 'and' and finally 'or'. So this expression evaluates to same value
    with or without parentheses.

  - For readability though I would keep parentheses.

--]]

