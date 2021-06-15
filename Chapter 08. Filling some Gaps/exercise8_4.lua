--[=[

  Exercise 8.4: As we saw in the section called “Proper Tail Calls”, a tail call
  is a goto in disguise. Using this idea, reimplement the simple maze game from
  the section called “break, return, and goto” using tail calls. Each block
  should become a new function, and each goto becomes a tail call.

--]=]

local room1, room2, room3, room4 -- make them all local

-- initial room

function room1()
  local move = io.read()
  if move == "south" then
    return room3()
  elseif move == "east" then
    return room2()
  else
    print("invalid move")
    return room1() -- stay in the same room
  end
end

function room2()
  local move = io.read()
  if move == "south" then
    return room4()
  elseif move == "west" then
    return room1()
  else
    print("invalid move")
    return room2()
  end
end

function room3()
  local move = io.read()
  if move == "north" then
    return room1()
  elseif move == "east" then
    return room4()
  else
    print("invalid move")
    return room3()
  end
end

function room4()
  print("Congratulations, you won!")
end

room1()
