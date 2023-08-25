# # Read the binary file
# rom_data = bytearray(open('data.bin', 'rb').read())
# rom_depth = len(rom_data)

# with open('rom_init.v', 'w') as f:
#   f.write("initial begin\n")
#   for i, data in enumerate(rom_data):
#     f.write(f"    memory[{i}] = 8'b{data:08b};\n")
#   f.write("end\n")


with open('data.hex', 'r') as f:
    lines = f.readlines()

with open('rom_init.v', 'w') as f:
    f.write("initial begin\n")
    for i, line in enumerate(lines):
        line = line.strip()  # Remove leading/trailing whitespace
        if len(line) != 8:
            print(f"Error: Line {i+1} does not have 8 characters")
            continue
        f.write(f"    memory[{i}] = 32'h{line};\n")
    f.write("end\n")