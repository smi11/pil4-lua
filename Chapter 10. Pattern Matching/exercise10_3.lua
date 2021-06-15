--[=[

  Exercise 10.3: Write a function transliterate. This function receives a string
  and replaces each character in that string with another character, according
  to a table given as a second argument. If the table maps a to b, the function
  should replace any occurrence of a with b. If the table maps a to false, the
  function should remove occurrences of a from the resulting string.

--]=]

function transliterate(s,t)
  -- use parenthesis to remove gsub's second return value (number of replacements)
  return (string.gsub(s,".",function(c)
                              if t[c] then return t[c]             -- transliterate character
                              elseif t[c] == false then return ""  -- remove character
                              end
                              return c                             -- leave character as it is
                            end))
end

print(transliterate("abcdefg",{a="b",b="a",d=false}))
--> bacefg

print(transliterate("abcdefg",{a="g",b="f",c="e",d=false,e="c",f="b",g="a"}))
--> gfecba

-- if character is not in transliterate table it is simply left as it is
-- otherwise it is transliterated according to specified rules
