--[=[

  Exercise 5.1: What will the following script print? Explain.

  sunday = "monday"; monday = "sunday"
  t = {sunday = "monday", [sunday] = monday}
  print(t.sunday, t[sunday], t[t.sunday])

--]=]

sunday = "monday"; monday = "sunday"

t = {sunday = "monday", [sunday] = monday} --> t["sunday"] = "monday"; t["monday"] = "sunday"
-- both key and value are literal strings
-- t = {sunday = "monday"} <--> t.sunday = "monday" <--> t["sunday"] = "monday"

-- both key and value are references to variables sunday and monday
-- t = {[sunday] = monday} <--> t["monday"] = "sunday"

print(t.sunday, t[sunday], t[t.sunday])     --> monday    sunday    sunday
-- t.sunday == "monday"
-- t[sunday] == t["monday"] == "sunday"
-- t[t.sunday] == t["monday"] == "sunday"
