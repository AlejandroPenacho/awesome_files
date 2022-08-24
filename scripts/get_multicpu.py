N_CORES = 4

def extract_cycles(line):
    all_cycles = line.split()[1:]
    total_cycles = sum(map(lambda x: int(x) ,all_cycles))
    idle_cycles = int(all_cycles[3])

    return (idle_cycles, total_cycles)



file = open("/proc/stat")
text = file.read()
file.close()

cpu_lines = text.splitlines()


idle_cycles, total_cycles = extract_cycles(cpu_lines[0])

out = f"{idle_cycles},{total_cycles}"

for cpu in range(N_CORES):
    idle_cycles, total_cycles = extract_cycles(cpu_lines[cpu+1])
    out += f";{idle_cycles},{total_cycles}"

print(out)
