--[[

  Exercise 3.7: Using math.random, write a function to produce a
  pseudo-random number with a standard normal (Gaussian) distribution.

  - I have used Box Muller algorithm described here:
    https://www.taygeta.com/random/gaussian.html

--]]

-- Pseudo-random generator with Gaussian distribution
--
-- if n is specified the function returns integer between 1 and n
-- if n is omitted it will return float between 0 and 1
function boxmuller(n)

  local m = 0.5   -- median
  local s = 0.2   -- standard deviation

  local x1, x2, w, y1, y2
 
  repeat
    x1 = 2 * math.random() - 1;
    x2 = 2 * math.random() - 1;
    w = x1 * x1 + x2 * x2;
  until w < 1;

  w = math.sqrt( (-2 * math.log( w ) ) / w )
  y1 = x1 * w;
  y2 = m + y1 * s

  -- ensure float value in range [0,1)
  if y2 < 0 or y2 >= 1 then
    y2 = boxmuller() -- find another number 
  end

  if n then
    return math.floor(1 + y2 * n)  -- integer [1,n]
  else
    return y2 -- float [0,1)
  end
end

function printchart(t,height)
  local t = t or {}
  local height = height or 25  -- default 25 if not provided
  local max = 0                -- which random number came up most times?
  local samples = 0            -- what is the highest index in our table?

  -- loop through table and find max value and highest samples
  for k,v in pairs(t) do
    max = math.max(v or 0,max)
    if k > samples then
      samples = k
    end
  end

  -- calculate coefficient k for multiplication so we have exact "height" of our chart
  local k = height / max

  -- draw the chart of generated random numbers with a Gaussian distribution
  for y=height,1,-1 do -- loop from top to bottom
    local row={}
    for x=1,samples do
      if (t[x] or 0) * k >= y then
        row[x] = "*"
      else
        row[x] = " "
      end
    end
    print(table.concat( row ))
  end
end

-- randomize seed
math.randomseed(os.time())

-- storage to collect random function results
local t = {}

-- this will also be the width of our chart
local samples = 80

-- generate random numbers and store their count into table t
for i = 1, 10000 do
  r = boxmuller(samples)     -- gives random number in range [1,samples]
  t[r] = ( t[r] or 0 ) + 1   -- count how many times that random number came up
end

printchart(t)
