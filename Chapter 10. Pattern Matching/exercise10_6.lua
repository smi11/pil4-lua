--[=[

  Exercise 10.6: Rewrite the function transliterate for UTF-8 characters.

--]=]

-- we just replace "." for single byte with multibyte utf8.charpattern

function transliterate(s,t)
  return (string.gsub(s,utf8.charpattern,function(c)
                                           if t[c] then return t[c]             -- transliterate character
                                           elseif t[c] == false then return ""  -- remove character
                                           end
                                           return c                             -- leave character as it is
                                         end))
end

print(transliterate("력사 역노",{["력"]="a",["사"]="b",["역"]=false}))
--> ab 노

print(transliterate("력čšžcsz",{["력"]="사",["č"]="c",["š"]="s",["ž"]="z",c="č",s="š",z="ž"}))
--> 사cszčšž
