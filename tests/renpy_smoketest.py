print("=== Ren'Py 8 Switch Python smoke test ===")

import sys
import os
import math
import time
import json
import pickle
import zlib
import hashlib
import unicodedata
import itertools
import functools
import random
import datetime
import heapq
import bisect
import csv

print("Python version:", sys.version)
print("Platform:", sys.platform)

# json
data = {"a": 1, "b": [1, 2, 3]}
assert json.loads(json.dumps(data)) == data

# pickle
blob = pickle.dumps(data)
assert pickle.loads(blob) == data

# zlib
compressed = zlib.compress(b"hello")
assert zlib.decompress(compressed) == b"hello"

# hashlib
assert hashlib.sha256(b"test").hexdigest()

# unicode
assert unicodedata.normalize("NFC", "é") == "é"

# random
random.seed(1234)
assert random.randint(0, 10) >= 0

print("ALL TESTS PASSED")
