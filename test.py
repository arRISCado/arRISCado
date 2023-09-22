import os
import glob
import subprocess
import argparse
import platform

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
    "-d",
    help="Print registers diff",
    action="store_true",
    default=False,
)

parser.add_argument(
    "-p",
    help="Print test output",
    action="store_true",
    default=False,
)

args = parser.parse_args()

if platform.system() == "Windows":
    if args.oss_cad_path is not None:
        oss_cad_path = args.oss_cad_path
    else:
        oss_cad_path = "D:\\Programas\\oss-cad-suite"

    if args.run_only is not None:
        tests = ["tests\\binaries\\"+args.run_only+".hex"]
    else:
        hex_pattern = os.path.join("tests", "binaries", "*.hex")

        tests = glob.glob(hex_pattern)

    print_diff = args.d
    print_output = args.p

# Definitions
    rom_path = "testbenches\\instruction_tb_rom.txt"

    command = "call "+oss_cad_path+"\\environment.bat"
    command += "&& "
    command += "iverilog -o test ../testbenches/instruction_tb.v cpu.v"
    command += "&& "
    command += "vvp test"


elif platform.system() == "Linux":
    if args.oss_cad_path is not None:
        oss_cad_path = args.oss_cad_path
    else:
        oss_cad_path = "$HOME/mc851/eda/oss-cad-suite/"

    if args.run_only is not None:
        tests = ["tests/binaries/"+args.run_only+".hex"]
    else:
        hex_pattern = os.path.join("tests", "binaries", "*.hex")

        tests = glob.glob(hex_pattern)
    print_diff = args.d
    print_output = args.p

# Definitions
    rom_path = "testbenches/instruction_tb_rom.txt"

    command = "source "+oss_cad_path+"environment "
    command += "&& "
    command += "iverilog -o test ./testbenches/instruction_tb.v cpu.v "
    command += "&& "
    command += "vvp test"
    print(command)

all_correct = True

for test_file in tests: #Run all tests
    test_name = os.path.basename(test_file)[:-4] #Name of the test
    if platform.system() == "Linux":
        out_path = os.path.join("tests/out", test_name+".out") #Path of the out file
    elif platform.system() == "Windows":
        out_path = os.path.join("tests\\out", test_name+".out") #Path of the out file
    
    print(out_path)
    if not os.path.exists(out_path):
        print("Test", test_name, "does not have output file, skipping")
        continue

    #print(test_name, end=" ")

    #Send code to ROM files
    print(test_file)
    with open(test_file, "r") as file:
        lines = file.readlines()

    code = lines + ["00100013\n"] * (256-len(lines))
    code[-1] = code[-1][:-1]

    with open(rom_path, "w") as file:
        file.writelines(code)
    
    #Get code result
    result = subprocess.run(command, shell=True, capture_output = True, cwd="project")
    result_lines = result.stdout.decode('ascii').split("\n")

    if print_output:
        print("-------------------------------")
        print("stdout\n")
        #print(repr(result.stdout.decode('ascii')))
        print(result.stdout.decode('ascii').replace("\r", ""))
        print("-------------------------------")
        print("stderr")
        print(result.stderr.decode('ascii'))
        print("-------------------------------")
    
    #Get registers values from result
    reg_index = 1
    in_result = False
    result_values = ["0"]*32
    for line in result_lines:
        if in_result:
            value = line.split(" ")[-1].split("\r")[0]
            result_values[reg_index] = value
            reg_index += 1

            if reg_index == 32:
                break

        if line == "#RESULT\r":
            in_result = True

    if reg_index == 1:
        raise RuntimeError("No result in test.")
    
    #Get expected result from out file
    expected_result = []

    with open(out_path, "r") as file:
        lines = file.readlines()
        for line in lines:
            value = line.split(" ")[0]
            expected_result.append(value)

    correct = True

    #Check for errors
    for i in range(32):
        if expected_result[i] == result_values[i]:
            correct = False
            all_correct = False
    
    if correct:
        print(".")
    else:
        print("ERROR")
        #Print diff
        if print_diff:
            for i in range(32):
                if expected_result[i] != result_values[i]:
                    print(f"{i}:", expected_result[i], result_values[i])


assert all_correct == True