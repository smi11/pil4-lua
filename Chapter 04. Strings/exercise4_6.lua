--[[

  Exercise 4.6: Redo the previous exercise for UTF-8 strings:

  > remove("ação", 2, 2) --> ao

  (Here, both the initial position and the length should be counted in
  codepoints.)

--]]

function remove(s,ofs,len)
  len = len or 1              -- if no len given assume 1 codepoint
  len = len < 0 and 0 or len  -- if negative len assume 0 codepoints
  if ofs < 0 then
    return table.concat{ string.sub(s,0,(utf8.offset(s,ofs) or 1)-1),
                         string.sub(s,ofs+len >= 0 and #s+1 or utf8.offset(s,ofs+len) or #s+1) }
  else
    return table.concat{ string.sub(s,0, ofs == 1 and 0 or (utf8.offset(s,ofs) or 0)-1),
                         string.sub(s,utf8.offset(s,ofs+len) or #s+1) }
  end
end

print(remove("ação", 2, 2))               --> ao
print(remove("ação", 2))                  --> aão
print(remove("ÃøÆËÐ", 1, 1))              --> øÆËÐ
print(remove("ÃøÆËÐ ÃøÆËÐ", 6, 5))        --> ÃøÆËÐÐ
print(remove("ação ÃøÆËÐ", 5, 10))        --> ação
print(remove("ação ÃøÆËÐ", 1, 4))         --> ÃøÆËÐ
print(remove("ação ÃøÆËÐ", 2, 2))         --> ao ÃøÆËÐ
print(remove("hello ÃøÆËÐ", 1))           --> ello ÃøÆËÐ
print(remove("hello ÃøÆËÐ", 1,-5))        --> hello ÃøÆËÐ
print(remove("hello ÃøÆËÐ", 15,2))        --> hello ÃøÆËÐ

-- negative index
print(remove("ação ÃøÆËÐ", -1, 2))       --> ação ÃøÆË
print(remove("ação ÃøÆËÐ", -2, 2))       --> ação ÃøÆ
print(remove("ação ÃøÆËÐ", -10, 2))       --> ão ÃøÆËÐ
print(remove("ação ÃøÆËÐ", -19, 18))       --> Ð
