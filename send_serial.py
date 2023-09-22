import serial  # pip install pyserial

port = "COM6"  # Insert port connected to board here

serialPort = serial.Serial(port=port, baudrate=115200, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

f = open("./tests/binaries/test.bin", "rt")  # Insert .hex file to be sent
code = f.read()

bindata = []
x = 0
y = 2
l = len(code)
while y <= l:
    if code[x] != '\r' and code[x] != '\n':
        bindata.append(int(code[x:y], 16))
        x += 2
        y += 2
    else:
        x += 1
        y += 1
serialPort.write(bindata)