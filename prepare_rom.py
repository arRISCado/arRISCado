# Read the binary file
rom_data = bytearray(open('data.bin', 'rb').read())
rom_depth = len(rom_data)

with open('rom_init.v', 'w') as f:
  f.write("initial begin\n")
  for i, data in enumerate(rom_data):
    f.write(f"    memory[{i}] = 8'b{data:08b};\n")
  f.write("end\n")
