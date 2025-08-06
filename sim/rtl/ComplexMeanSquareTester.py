import fileinput

class ComplexNumber:
    def __init__(self, real: int, img: int, bitwidth: int):
        self.bitwidth = bitwidth
        self.bitmask = (1 << (bitwidth // 2)) - 1
        self.max_unsigned = 1 << (bitwidth // 2)
        self.negative_overflow = 1 << (bitwidth // 2 - 1)
        self.img = img & self.bitmask
        if self.img >= self.negative_overflow:
            self.img -= self.max_unsigned
        self.real = real & self.bitmask
        if self.real >= self.negative_overflow:
            self.real -= self.max_unsigned

    @classmethod
    def fromnumber(cls, number: int, bitwidth: int):
        return cls(number, number >> (bitwidth // 2), bitwidth)

    @classmethod
    def add(cls, a, b):
        return cls(a.real + b.real, a.img + b.img, a.bitwidth)

    @classmethod
    def sub(cls, a, b):
        return cls(a.real - b.real, a.img - b.img, a.bitwidth)

    @classmethod
    def mult(cls, a, b):
        return cls(a.real * b.real - a.img * b.img, a.real * b.img + a.img * b.real, a.bitwidth * 2)

    def __eq__(self, other):
        if isinstance(other, ComplexNumber):
            return self.bitwidth == other.bitwidth and self.img == other.img and self.real == other.real
        return False

    def __str__(self):
        return f"({self.real},{self.img})"


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
    print (a, b, "a - b = ", diff)
    currentSum = ComplexNumber.add(currentSum, ComplexNumber.mult(diff, diff))
print(f"Read {lineCounter - 1} numbers")
result = ComplexNumber.fromnumber(int(line_split[0]), 64)
expected = ComplexNumber(currentSum.real // (lineCounter - 1), currentSum.img // (lineCounter - 1), 64)
if result != expected:
    print(f"Unexepected result: Expected {expected} got {result}")
    exit(1)
print("Testing passed!")
