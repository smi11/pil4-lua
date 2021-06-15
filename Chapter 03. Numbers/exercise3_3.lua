--[[

  Exercise 3.3: What will the following program print?

    for i = -10, 10 do
      print(i, i % 3)
    end

  - "%" is an operator for modulo. 

    In the first column we would get number i in the range from -10 to 10. Second
    column would show us a result of modulo of i, which is a number in the range
    from 0 to 2 in our case. Modulo is a reminder after integer division with
    that number.

    a % b == a - ((a // b) * b)

    For example first row would first print number -10 and then in the second
    column number 2 since -10 - ((-10 // 3) * 3) = 2.

    Full output of that loop is:

    -10     2
    -9      0
    -8      1
    -7      2
    -6      0
    -5      1
    -4      2
    -3      0
    -2      1
    -1      2
    0       0
    1       1
    2       2
    3       0
    4       1
    5       2
    6       0
    7       1
    8       2
    9       0
    10      1

--]]

for i = -10, 10 do
  print(i, i % 3)
end
