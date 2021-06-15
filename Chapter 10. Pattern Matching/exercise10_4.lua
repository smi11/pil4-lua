--[=[

  Exercise 10.4: At the end of the section called “Captures”, we defined a trim
  function. Because of its use of backtracking, this function can take a
  quadratic time for some strings. (For instance, in my new machine, a match for
  a 100 KB string can take 52 seconds.)

  • Create a string that triggers this quadratic behavior in function trim.
  • Rewrite that function so that it always works in linear time.

--]=]

-- 1. According to http://lua-users.org/wiki/StringTrim the worst case scenario 
--    for trim1 is when we have a string like "  a b c d e f g h i j k l m n ... "

-- 2. Best option using string library seems to be trim12

-- trim implementations
-- http://lua-users.org/wiki/StringTrim
-- I have kept only string library solutions

function trim1(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end
-- from PiL

function trim2(s)
   return s:match "^%s*(.-)%s*$"
end
-- variant of trim1 (match)

function trim3(s)
   return s:gsub("^%s+", ""):gsub("%s+$", "")
end
-- two gsub's

function trim4(s)
   return s:match"^%s*(.*)":match"(.-)%s*$"
end
-- variant of trim3 (match)

function trim5(s)
   return s:match'^%s*(.*%S)' or ''
end
-- warning: has bad performance when s:match'^%s*$' and #s is large

function trim6(s)
   return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end
-- fixes performance problem in trim5.
-- note: the '()' avoids the overhead of default string capture.
-- This overhead is small, ~ 10% for successful whitespace match call
-- alone, and may not be noticeable in the overall benchmarks here,
-- but there's little harm either.  Instead replacing the first `match`
-- with a `find` has a similar effect, but that requires localizing
-- two functions in the trim7 variant below.

local match = string.match
function trim7(s)
   return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end
-- variant of trim6 (localize functions)

local find = string.find
local sub = string.sub
function trim8(s)
   local i1,i2 = find(s,'^%s*')
   if i2 >= i1 then
      s = sub(s,i2+1)
   end
   local i1,i2 = find(s,'%s*$')
   if i2 >= i1 then
      s = sub(s,1,i1-1)
   end
   return s
end
-- based on penlight 0.7.2

function trim9(s)
   local _, i1 = find(s,'^%s*')
   local i2 = find(s,'%s*$')
   return sub(s, i1 + 1, i2 - 1)
end
-- simplification of trim8

function trim10(s)
   local a = s:match('^%s*()')
   local b = s:match('()%s*$', a)
   return s:sub(a,b-1)
end
-- variant of trim9 (match)

function trim11(s)
   local n = s:find"%S"
   return n and s:match(".*%S", n) or ""
end
-- variant of trim6 (use n position)
-- http://lua-users.org/lists/lua-l/2009-12/msg00904.html

function trim12(s)
   local from = s:match"^%s*()"
   return from > #s and "" or s:match(".*%S", from)
end
-- variant of trim11 (performs better for all
-- whitespace string). See Roberto's comments
-- on ^%s*$" v.s. "%S" performance:
-- http://lua-users.org/lists/lua-l/2009-12/msg00921.html

-- test utilities

local function trimtest(trim)
   assert(trim'' == '')
   assert(trim' ' == '')
   assert(trim'  ' == '')
   assert(trim'a' == 'a')
   assert(trim' a' == 'a')
   assert(trim'a ' == 'a')
   assert(trim' a ' == 'a')
   assert(trim'  a  ' == 'a')
   assert(trim'  ab cd  ' == 'ab cd')
   assert(trim' \t\r\n\f\va\000b \r\t\n\f\v' == 'a\000b')
end

local function perftest(f, s)
   local time = os.clock  -- os.time or os.clock
   local t1 = time()
   for i=1,100000 do
      f(s)
      f(s)
      f(s)
      f(s)
      f(s)
      f(s)
      f(s)
      f(s)
      f(s)
      f(s)
   end
   local dt = time() - t1
   io.stdout:write(("%4.1f"):format(dt) .. " ")
end

local trims = {trim1, trim2, trim3, trim4, trim5, trim6, trim7,
               trim8, trim9, trim10, trim11, trim12}

-- correctness tests
for _,trim in ipairs(trims) do
   trimtest(trim)
end

-- performance tests
for i,trim in ipairs(trims) do
  io.stdout:write(string.format("%2d",i) .. ": ")
  perftest(trim,  "")
  perftest(trim,  "abcdef")
  perftest(trim,  "   abcdef   ")
  perftest(trim,  "abcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef")
  perftest(trim,  "  a b c d e f g h i j k l m n o p q r s t u v w x y z A B C ")
  perftest(trim,  "                               a                            ")
  perftest(trim,  "                                                            ")
  print()
end
