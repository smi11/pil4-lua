--[=[

  Exercise 13.7: Suppose we have a binary file with a sequence of records, each
  one with the following format:
  
    struct Record {
      int x;
      char[3] code;
      float value;
    };

  Write a program that reads that file and prints the sum of the value fields.

--]=]

-- create some records and write them to temporary file

local f = assert(io.tmpfile()) -- tmpfile opens in r/w mode

for i = 1,10 do  -- we'll write 10 records
  local value = math.pi * i
  local s = string.pack("ic3d", i, "abc", value) -- integer, 3 character string, float (double)
  f:write(s)
end

f:flush()        -- make sure a file is written to disk
f:seek("set")    -- seek back to start

-- read the records from file and print sum of value fields

local s = f:read("a") -- read whole file to string s
local valuesum = 0

local i = 1
while i <= #s do -- loop through all records
  local ind, code, value
  ind, code, value, i = string.unpack("ic3d", s, i)
  valuesum = valuesum + value
end

f:close()

assert(valuesum == math.pi * 55) -- verify result (it should be 55 times math.pi)

print("Sum of value is ", valuesum)
--> Sum of value is   172.78759594744
