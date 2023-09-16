import os
import glob
import subprocess
import argparse

# Arguments

parser = argparse.ArgumentParser()

parser.add_argument(
    "-c", "--oss_cad_path",
    help="Path of OSS CAD Suite",
    type=str,
)

parser.add_argument(
    "-r", "--run_only",
    help="If specified, will only run the test with the name. Test must be in tests folder, and \
            the name must not have an extension",
    type=str,
)

parser.add_argument(
    "-p",
    help="Print registers diff",
    action="store_true",
    default=False,
)

args = parser.parse_args()

if args.oss_cad_path is not None:
    oss_cad_path = args.oss_cad_path
else:
    oss_cad_path = "D:\\Programas\\oss-cad-suite"

if args.run_only is not None:
    tests = ["tests\\binaries\\"+args.run_only+".hex"]
else:
    hex_pattern = os.path.join("tests", "binaries", "*.hex")

    tests = glob.glob(hex_pattern)

print_diff = args.p

# Definitions

rom_path = "testbenches\\instruction_tb_rom.txt"

command = "call "+oss_cad_path+"\\environment.bat"
command += "&& "
command += "iverilog -o test ../testbenches/instruction_tb.v cpu.v"
command += "&& "
command += "vvp test"


for test_file in tests: #Run all tests
    test_name = os.path.basename(test_file)[:-4] #Name of the test
    out_path = os.path.join("tests", test_name+".o") #Path of the out file

    if not os.path.exists(out_path):
        print("Test", test_name, "does not have output file, skipping")
        continue

    print(test_name)

    #Send code to ROM files
    with open(test_file, "r") as file:
        lines = file.readlines()

    code = lines + ["00100013\n"] * (256-len(lines))
    code[-1] = code[-1][:-1]

    with open(rom_path, "w") as file:
        file.writelines(code)
    
    #Get code result
    result = subprocess.run(command, shell=True, capture_output = True, cwd="project")
    result_lines = result.stdout.decode('ascii').split("\n")
    
    #Get registers values from result
    reg_index = 1
    in_result = False
    result_values = ["0"]*32
    for line in result_lines:
        if in_result:
            value = line.split("          ")[-1].split("\r")[0]
            result_values[reg_index] = value
            reg_index += 1

            if reg_index == 32:
                break

        if line == "#RESULT\r":
            in_result = True

    
    #Get expected result from out file
    expected_result = []

    with open(out_path, "r") as file:
        lines = file.readlines()
        for line in lines:
            value = line.split(" ")[0]
            expected_result.append(value)
    
    #Print diff
    if print_diff:
        for i in range(32):
            print(f"{i}:", expected_result[i], result_values[i], end="")

            if expected_result[i] != result_values[i]:
                print(" ERROR")
            else:
                print()

    #Assert values
    for i in range(32):
        assert expected_result[i] == result_values[i]