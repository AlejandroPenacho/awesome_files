import subprocess

all_data = subprocess.run(["df"], stdout=subprocess.PIPE).stdout

line = all_data.splitlines()[3].decode().split()


print(f"{line[1]},{line[2]},{line[3]},{line[4][:-1]}")
