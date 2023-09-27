file_path =  "result.txt"

file = open(file_path, "r", encoding="utf-16")
text = file.read()
file.close()

out_file = open("result.csv", "w")

steps = text.split("#STEP_START\n")

for step in steps:
    if step.find("#STEP_END") == -1:
        continue
    step = step.split("#STEP_END")[0]

    out_file.write("\"")
    out_file.write(step)
    out_file.write("\",")


out_file.close()