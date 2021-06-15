--[=[

  Exercise 5.7: Write a function that inserts all elements of a given list into
  a given position of another given list.

--]=]

-- insert list1 into list2 at position pos in list2
function insert(list1, pos, list2)

  table.move(list2, pos, #list2, pos+#list1)  -- shift elements in list2 to make room for list1
  table.move(list1, 1, #list1, pos, list2)    -- copy elements from list1 to list2 at pos
  return list2
end

-- very simple print table
function tp(t, len)
  len = len or #t                   -- if len not specified assume #t
  for i=1,len do
    if t[i] ~= nil then 
      io.write(tostring(t[i])," ")
    else
      io.write("- ")                -- print "-" at empty positions
    end
  end
  io.write("\n")
end

-- init test table
function itt()
  return { 1, 2, 3, 4, 5, 6 }
end

list = itt(); tp(insert({"a", "b"}, 3, list))           --> 1 2 a b 3 4 5 6
list = itt(); tp(insert({"a", "b"}, 1, list))           --> a b 1 2 3 4 5 6
list = itt(); tp(insert({"a", "b"}, #list+1, list))     --> 1 2 3 4 5 6 a b
list = itt(); tp(insert({"a", "b"}, #list+3, list),10)  --> 1 2 3 4 5 6 - - a b
list = itt(); tp(insert({"a", "b"}, #list+5, list),12)  --> 1 2 3 4 5 6 - - - - a b
list = itt(); tp(insert({"a", "b"}, #list, list))       --> 1 2 3 4 5 a b 6
list = itt(); tp(insert({"X"}, 1, list))                --> X 1 2 3 4 5 6
