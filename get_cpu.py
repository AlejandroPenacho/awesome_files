
def extract_cycles(line):
    all_cycles = line.split()[1:]
    total_cycles = sum(map(lambda x: int(x) ,all_cycles))
    idle_cycles = int(all_cycles[3])

    return (idle_cycles, total_cycles)



file = open("/proc/stat")
text = file.read()
file.close()

first_line = text.splitlines()[0]

idle_cycles, total_cycles = extract_cycles(first_line)

print(f"{idle_cycles},{total_cycles}")
