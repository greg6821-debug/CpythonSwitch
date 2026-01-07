print("=== Ren'Py 8 Python compatibility test ===")

def ok(name):
    print("[OK]", name)

def fail(name, e):
    print("[FAIL]", name, e)

tests = [
    "sys", "os", "math", "time", "json", "zlib", "binascii",
    "struct", "array", "hashlib", "random", "codecs",
    "unicodedata", "collections", "functools", "itertools",
    "heapq", "bisect", "datetime", "csv", "re"
]

for m in tests:
    try:
        __import__(m)
        ok(m)
    except Exception as e:
        fail(m, e)

import sys, os
print("platform:", sys.platform)
print("maxsize:", sys.maxsize)
print("byteorder:", sys.byteorder)

# filesystem check
try:
    with open("sdmc:/renpy_test.txt", "w") as f:
        f.write("ok")
    ok("sdmc write")
except Exception as e:
    fail("sdmc write", e)

print("=== TEST END ===")
