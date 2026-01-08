print("Running Python test on Switch")
print("sys.version:")
import sys
print(sys.version)

def fib(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

print("fib(10) =", fib(10))
