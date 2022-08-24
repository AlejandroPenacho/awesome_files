import urllib.request

reponse = urllib.request.urlopen("http://whatismyip.akamai.com")

external_ip = response.read().decode()

print(external_ip)


# internal_ip = 
