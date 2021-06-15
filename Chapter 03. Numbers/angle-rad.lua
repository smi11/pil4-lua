local tolerance = 0.17

function isturnback (angle)
  angle = angle % (2*math.pi)
  return (math.abs(angle - math.pi) < tolerance)
end

-- This definition works even for negative angles:

print(isturnback(-math.pi)) --> true
