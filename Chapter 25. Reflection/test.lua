local function cc(x)
  return function ()
    x = math.floor(x + 1)
    return tostring(x-1)
  end
end

function test()
  io.write("test\n")
end

a = cc(10)

io.write(a(),a(),a(),"\n")
test()
test()
test()

for i = 1,300 do
  a()
end

io.write"---\n"
