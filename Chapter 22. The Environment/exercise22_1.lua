--[=[

  Exercise 22.1: The function getfield that we defined in the beginning of this
  chapter is too forgiving, as it accepts “fields” like math?sin or
  string!!!gsub. Rewrite it so that it accepts only single dots as name
  separators.

--]=]

-- return nil if f is invalid or f doesn't exist
function getfield (f)
  local v = _G -- start with the table of globals
  if type(f) ~= "string" then return nil end -- make sure we have correct type of f
  local w, pos = "", 1
  repeat
    w, pos = string.match(f, "^([%a_][%w_]*)()",pos) -- match identifier
    v = v[w]
    if pos and pos <= #f then -- dot must follow identifier
      pos = string.match(f, "^%.()",pos) -- match dot
      if not pos or (pos and pos > #f) then v = nil end -- missing dot or extra dot
    end
  until not pos or pos > #f or v == nil
  return v
end

a = { b = { c = 123 } }
b = false
c = nil
print(getfield("math?sin"))       --> nil
print(getfield("string!!!gsub"))  --> nil
print(getfield("math.sin"))       --> function: 0x487a19ee0
print(getfield(".math.sin"))      --> nil (must not start with dot)
print(getfield("math.sin."))      --> nil (extra dot at the end)
print(getfield("string.gsub"))    --> function: 0x487a1df70
print(getfield("unknown.x"))      --> nil
print(getfield("a.b.c"))          --> 123
print(getfield("b"))              --> false
print(getfield("c"))              --> nil
print(getfield("_G"))             --> table: 0x800000490
print(getfield("_G._G"))          --> table: 0x800000490
print(getfield(""))               --> nil (empty string)
print(getfield())                 --> nil (argument missing)
print(getfield(11))               --> nil (number)
print(getfield(false))            --> nil (boolean)
print(getfield({}))               --> nil (table)
print(getfield("11"))             --> nil (invalid identifier)
print(getfield("#$%??"))          --> nil (invalid identifier)
