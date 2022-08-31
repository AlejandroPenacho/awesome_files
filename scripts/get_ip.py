import urllib.request

import subprocess
import re

response = urllib.request.urlopen("http://whatismyip.akamai.com")

external_ip = response.read().decode()

ip_output = subprocess.run(["ip","address"], stdout=subprocess.PIPE).stdout.decode()

regex = re.compile(r"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")

internal_ip = re.findall(regex, ip_output)[1]

print(f"{internal_ip},{external_ip}")
