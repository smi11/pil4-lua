function fsize (file)
  local current = file:seek() -- save current position
  local size = file:seek("end") -- get file size
  file:seek("set", current) -- restore position
  return size
end

local f = assert(io.open("fsize.lua", "r"))
print(fsize(f))
f:close()
