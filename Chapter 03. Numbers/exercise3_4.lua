--[[

  Exercise 3.4: What is the result of the expression 2^3^4? What about 2^-3^4?

  1. 2^3^4 = 2^(3^4) = 2^81 = 2.4178516392293e+24

     exponentiation is right associateive therefore 3^4 will be evaluated first
     which is 81 and then 2^81 which is 2.4178516392293e+24.

  2. 2^-3^4 = 2^(-3^4) = 2^-81 = 4.1359030627651e-25

     same logic as in first case

--]]

print("2^3^4 = ",2^3^4)     --> 2.4178516392293e+24
print("2^-3^4 = ",2^-3^4)   --> 4.1359030627651e-25
