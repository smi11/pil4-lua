local set1 = require"exercise20_1"
local set2 = require"exercise20_2"

s1 = set1.new{10, 20, 30, 50}
s2 = set1.new{30, 1}

print(s1)                 --> {10, 20, 30, 50}
print(s2)                 --> {1, 30}

s3 = s1 + s2
print(s3)                 --> {1, 10, 20, 30, 50}
print((s1 + s2)*s1)       --> {10, 20, 30, 50}
print(s1 - s2)            --> {10, 20, 50}
print(s2 - s1)            --> {1}

s1 = set2.new{10, 20, 30, 50}
s2 = set2.new{30, 1}

print(#s1, s1)            --> 4       {10, 20, 30, 50}
print(#s2, s2)            --> 2       {1, 30}
