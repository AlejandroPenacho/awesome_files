import subprocess
import re

iwconfig_output = subprocess.run(
    ["iwconfig"],
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL
).stdout.decode()

ssid_regex = re.compile(r'(?<=ESSID:").*(?=")')
ssid = re.search(ssid_regex, iwconfig_output)

strength_regex = re.compile(r'(?<=Link Quality=)([0-9]+)/([0-9]+)')
strength_match = re.search(strength_regex, iwconfig_output)
strength = int(strength_match[1])/int(strength_match[2])

print(f"{ssid[0]},{int(strength*100)}")
