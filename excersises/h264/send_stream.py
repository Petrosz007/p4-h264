import os

os.system("ifconfig eth0 mtu 40000")
# os.system("tcpreplay -i eth0 -K --pps 5 8000rtsp.pcap")
os.system("tcpreplay -i eth0 -K -q -l 100 8000rtsp.pcap")
