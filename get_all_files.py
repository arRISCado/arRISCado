import os
import glob

files = glob.glob("**/*.v", root_dir="project", recursive=True)



files_str = " ".join(files)

print(files_str)