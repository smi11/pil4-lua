--[=[

  Exercise 6.1: Write a function that takes an array and prints all its
  elements.

--]=]

function printarray(a)
  for k,v in pairs(a) do
    if type(k) == "number" and k % 1 == 0 then -- ignore non-array entries with non-integer key
      print(v)
    end
  end
end


printarray{1, 2, "hello", [3.14]="pi", "world"} -- non-array elements are ignored
--> 1
--> 2
--> hello
--> world

printarray{"a", "b", nil, "c"}  --  nil value is not printed as it doesn't exists in array
--> a
--> b
--> c

printarray{"a", "b", 1, 2, 3, a=123} -- non-array elements are ignored
--> a
--> b
--> 1
--> 2
--> 3
