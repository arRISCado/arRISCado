file_path =  "result.txt"

file = open(file_path, "r", encoding="utf-16")
text = file.read()
file.close()

out_file = open("result.csv", "w")

steps = text.split("#STEP_START\n")

lines = [[] for _ in range(15)]

for step in steps:
    if step.find("#STEP_END") == -1:
        continue
    step = step.split("#STEP_END")[0]

    step_stages = step.split("\n\n")

    for i in range(len(step_stages)):
        lines[i].append(step_stages[i])

for line in lines:
    for column in line:
        out_file.write("\"")
        out_file.write(column)
        out_file.write("\",")

    out_file.write("\n")


out_file.close()