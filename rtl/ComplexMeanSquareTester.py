import fileinput
from ComplexNumber import ComplexNumber

currentSum = ComplexNumber.fromnumber(0, 64)
lineCounter = 0
for line in fileinput.input():
    lineCounter += 1
    line_split = line.strip().split()
    if len(line_split) != 2: # last line
        break
    a = ComplexNumber.fromnumber(int(line_split[0]), 32)
    b = ComplexNumber.fromnumber(int(line_split[1]), 32)
    diff = ComplexNumber.sub(a, b)
    currentSum = ComplexNumber.add(currentSum, ComplexNumber.mult(diff, diff))
print(f"Read {lineCounter - 1} numbers")
result = ComplexNumber.fromnumber(int(line_split[0]), 64)
expected = ComplexNumber(currentSum.real // (lineCounter - 1), currentSum.img // (lineCounter - 1), 64)
if result != expected:
    print(f"Unexepected result: Expected {expected} got {result}")
    exit(1)
print("Testing passed!")