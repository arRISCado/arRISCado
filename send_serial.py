import serial  # pip install pyserial
import sys
import time

if len(sys.argv) != 3:
    print("Script usage: python3 send_serial.py <Board port> <test file>")
    print("Example: python3 send_serial.py COM4 TestsArith.hex")
    exit()

#To check your port use python3 -m serial.tools.list_ports -v
port = sys.argv[1]
test_path = "./tests/binaries/" + sys.argv[2]

serialPort = serial.Serial(port=port, baudrate=115200, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

f = open(test_path, "rt")
code = f.read()
code = code.replace('\n', '')
code = code.replace('\r', '')
code = code.replace(' ', '')

bindata = []
x = 0
y = 2
l = len(code)
bindata.append(int(l/8))  # Amount of instructions
while y <= l:
    if code[x] != '\r' and code[x] != '\n':
        bindata.append(int(code[x:y], 16))
        x += 2
        y += 2
    else:
        x += 1
        y += 1

for data in bindata:
    serialPort.write([data])
    print("Sent: ", hex(data))
    time.sleep(1)