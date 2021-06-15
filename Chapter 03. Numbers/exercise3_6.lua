--[[

  Exercise 3.6: Write a function to compute the volume of a right
  circular cone, given its height and the angle between a generatrix
  and the axis.

  - h = given height of the cone
    X = given angle between a generatrix and the axis

    r = h tan(X)    -- radius
    A = π r^2       -- area of bottom circle of cone
    V = (1/3) h A   -- volume of a cone
--]]

function conevolume(h, angle)
  h = math.abs(h) -- make sure cone is upside
  assert(h>0,"Cone should have some height")

  local X = 2*math.pi / 360 * angle   -- angle in radians
  local r = h * math.tan(X)           -- radius
  local A = math.pi * r^2             -- area of bottom circle of cone
  local V = 1/3 * h * A               -- volume

  -- impossible cone?
  if angle >= 90 then V = math.huge end

  return V
end

local height = 10

for i=0,100,5 do
  print(string.format("Height = %i, Angle = %3i, V = %g", height, i, conevolume(height,i)))
end
