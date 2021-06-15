--[=[

  Exercise 8.6: Assuming that a goto could jump out of a function, explain what
  the program in Figure 8.3, “A strange (and invalid) use of a goto” would do.

  (Try to reason about the label using the same scoping rules used for local
  variables.)

  - The program would print numbers from 10 down to 1. Variable x would get a
    reference to function getlabel(). And executing that function we would get
    return value 0.

    Basically in function getlabel() if we replaced statement 'goto L1' with
    'return 0' it would be equivalent as if goto was actually able to jump out
    of its scope as it is written now. In a way label L1 is an upvalue for
    function in return statement.

--]=]

function getlabel ()
  return function () goto L1 end
 ::L1::
  return 0
end

function f (n)
  if n == 0 then
    return getlabel()
  else
    local res = f(n - 1)
    print(n)
    return res
  end
end

x = f(10)
x()
