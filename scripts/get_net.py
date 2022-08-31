
with open("/proc/net/dev") as file:
    all_lines = map(lambda x: x.split(), file.read().splitlines()[2:])


data = map(lambda x: (x[0][:-1], x[1], x[9]), all_lines)


wifi_connected = 0
eth_connected = 0

received = 0
transmitted = 0

for interface in data:
    if interface[0] == "wlp1s0":
        wifi_connected = 1
        received += int(interface[1])
        transmitted += int(interface[2])

print(f"{eth_connected},{wifi_connected},{received},{transmitted}")
