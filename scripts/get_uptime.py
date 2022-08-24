
with open("/proc/uptime") as file:
    print(file.read().split()[0])
