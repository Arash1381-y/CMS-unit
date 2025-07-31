import fileinput
from ComplexNumber import ComplexNumber

lineCounter = 0
for line in fileinput.input():
    lineCounter += 1
    line_split = line.split()
    if len(line_split) != 5:
        continue
    a = ComplexNumber.fromnumber(int(line_split[0]), 32)
    b = ComplexNumber.fromnumber(int(line_split[2]), 32)
    if line_split[1] == '+':
        result = ComplexNumber.fromnumber(int(line_split[4]), 32)
        expected = ComplexNumber.add(a, b)
        if result != expected:
            print("Erorr on line", line, lineCounter)
            print(f"{a} + {b} = {result} (expected {expected})")
            exit(1)
    elif line_split[1] == '-':
        result = ComplexNumber.fromnumber(int(line_split[4]), 32)
        expected = ComplexNumber.sub(a, b)
        if result != expected:
            print("Erorr on line", line, lineCounter)
            print(f"{a} - {b} = {result} (expected {expected})")
            exit(1)
    elif line_split[1] == '*':
        result = ComplexNumber.fromnumber(int(line_split[4]), 64)
        expected = ComplexNumber.mult(a, b)
        if result != expected:
            print("Erorr on line", line, lineCounter)
            print(f"{a} * {b} = {result} (expected {expected})")
            exit(1)
        result = ComplexNumber.fromnumber(int(line_split[4]), 64)
        pass
    else:
        raise Exception("Unhandled operation: " + line)
    
print("Testing passed!")