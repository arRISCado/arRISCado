import serial  # pip install pyserial

port = "COM4"  # Insert port connected to board here

serialPort = serial.Serial(port=port, baudrate=115200, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

f = open("./tests/binaries/TestsArith.hex", "rt")
code = f.read()

ascii_string = ''
x = 0
y = 2
l = len(code)
while y <= l:
    if code[x] != '\r' and '\n':
        ascii_string += chr(int(code[x:y], 16))
    x += 2
    y += 2
print(ascii_string)
print(str.encode(ascii_string))
serialPort.write(str.encode(ascii_string))