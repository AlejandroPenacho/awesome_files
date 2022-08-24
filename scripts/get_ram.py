import subprocess


all_data = subprocess.run(["free"], stdout=subprocess.PIPE).stdout.decode().splitlines()[1].split()

total = all_data[1]
free = all_data[3]
available = all_data[6]

print(f"{total},{free},{available}")
