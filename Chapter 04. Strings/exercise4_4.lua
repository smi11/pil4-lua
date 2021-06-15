--[[

  Exercise 4.4: Redo the previous exercise for UTF-8 strings:

  > insert("ação", 5, "!") --> ação!

  (Note that the position now is counted in codepoints.)

--]]

function insert(s,ofs,ins)
  -- negative offset needs different calculation
  if ofs < 0 then
    -- there are more edge cases here
    -- utf8.offset returns nil for out of range offsets
    return table.concat{ ofs == -1 and string.sub(s,0,-1) or string.sub(s,0,(utf8.offset(s, ofs+1) or 1)-1),
                         ins,
                         ofs == -1 and "" or string.sub(s,utf8.offset(s, ofs+1) or 0) }
  else
    return table.concat{ string.sub(s,0,(utf8.offset(s, ofs) or (#s+1)) - 1 ),
                         ins,
                         string.sub(s,utf8.offset(s, ofs) or (#s+1)) }
  end
end

print(insert("ação", 5, "!"))                         --> ação!
print(insert("ação résumé", 1, "start: "))            --> start: ação résumé
print(insert("ação résumé", 6, "Månen "))             --> ação Månen résumé

-- few extra with negative index
print(insert("ação résumé", -7, "Månen "))            --> ação Månen résumé
print(insert("ação résumé", -1, "!"))                 --> ação résumé!
print(insert("ação résumé", -8, ","))                 --> ação, résumé

print(insert("ação résumé", 5, ","))                  --> ação, résumé
