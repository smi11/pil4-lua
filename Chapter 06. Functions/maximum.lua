function maximum (a)
  local mi = 1 -- index of the maximum value
  local m = a[mi] -- maximum value
  for i = 1, #a do
    if a[i] > m then
      mi = i; m = a[i]
    end
  end
  return m, mi -- return the maximum and its index
end

print(maximum({8,10,23,12,5})) --> 23 3
