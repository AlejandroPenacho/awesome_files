
with open("/proc/net/dev") as file:
    all_lines = list(map(lambda x: x.split(), file.read().splitlines()[2:]))


data = map(lambda x: (x[0][:-1], x[1], x[9]), all_lines)

output = ""

for point in data:
    output += f"{point[0]},{point[1]},{point[2]};"

print(output[:-1])
