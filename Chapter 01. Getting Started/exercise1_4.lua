--[[

  Exercise 1.4: Which of the following strings are valid identifiers?

    ___ _end End end until? nil NULL one-step

  - Valid: ___ _end End NULL

  - Not valid: end until? nil one-step

--]]

___ = true
assert(___)

_end = true
assert(_end)

End = true
assert(End)

-- end is reserved word

-- until? contains "?" which is not valid character for identifiers

-- nil is a data type and not valid as an identifier

NULL = true
assert(NULL)

-- one-step contains "-" which is not valid character for identifiers
