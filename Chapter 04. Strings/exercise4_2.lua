--[[

  Exercise 4.2: Suppose you need to write a long sequence of arbitrary bytes
  as a literal string in Lua. What format would you use? Consider issues
  like readability, maximum line length, and size.

  - Printable ASCII characters I would keep as they are to save on size. Any
    non-printable characters I would encode as an escape character such as \000
    or \x00 in hex.
    Further more I would keep the lines at certain width and separate them using
    \z escape sequence.

--]]

data = "\x00\x01\x02\x03\x04\x05\x06\x07\z
        \x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\z
        That was part of string with non\z
        -printable characters. This part\z
        \x20is printable."
