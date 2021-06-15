--[=[

  Exercise 9.5: In our system for geometric regions, add a function to rotate a
  given region by a given angle.

--]=]

function disk (cx, cy, r)
  return function (x, y)
           return (x - cx)^2 + (y - cy)^2 <= r^2
           end
end

function rect (left, right, bottom, up)
  return function (x, y)
           return left <= x and x <= right and
                  bottom <= x and x <= up
           end
end

function complement (r)
  return function (x, y)
           return not r(x, y)
           end
end

function union (r1, r2)
  return function (x, y)
           return r1(x, y) or r2(x, y)
         end
end

function intersection (r1, r2)
  return function (x, y)
           return r1(x, y) and r2(x, y)
         end
end

function difference (r1, r2)
  return function (x, y)
           return r1(x, y) and not r2(x, y)
         end
end

function translate (r, dx, dy)
  return function (x, y)
           return r(x - dx, y - dy)
          end
end

function rotate (r, angle)
  return function (x, y)
           local o = angle * math.pi / 180
           return r(x * math.cos(o) - y * math.sin(o),
                    x * math.sin(o) + y * math.cos(o))
          end
end

function plot (r, M, N)
  io.write("P1\n", M, " ", N, "\n") -- header
  for i = 1, N do -- for each line
    local y = (N - i*2)/N
    for j = 1, M do -- for each column
      local x = (j*2 - M)/M
      io.write(r(x, y) and "1" or "0")
    end
    io.write("\n")
  end
end

c1 = disk(0, 0, 1)
-- rotate the crescent moon by -45 degrees
plot(rotate(difference(c1, translate(c1, 0.3, 0)),-45), 80, 45)
