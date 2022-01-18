# Python 3
# Author: Alexander Kellermann Nieves
# Date: September 16th 2018
#
# Using scapy, write a script to find all host on LAN that are in promiscuous mode.
#
# The source I used for coming up with the parameters for crafting 
# the arp packet is from the following website
# Source : http://www.securityfriday.com/promiscuous_detection_01.pdf
from scapy.all import *
import ipaddress

def main():
    # This gets our current IP address
    our_host = socket.gethostbyname(socket.gethostname())
    print("Our Host is: {}".format(our_host))
    every_ip_on_network(our_host + '/24')
    print("Done.")

def every_ip_on_network(host):
    host4 = ipaddress.ip_interface(host)
    for address in host4.network.hosts():
        # This runs for each host that CAN exist on the network.
        # Because of the nature of this experiment, we have to bruteforce
        # all possible IP addresses
        response = srp1(craft_ether_packet(address.__str__()), timeout=1, verbose=0)
        if response:
            print("Potential sniffer at {}".format(address.__str__()))

def craft_ether_packet(ip_address):
    # Here we craft the ARP packet
    arp_detect = ARP()
    # Here we assign the destination to whatever is given in ip_address
    arp_detect.pdst = ip_address
    # Here we generate the layer 2 address. It's important to note that the last
    # bit is not F and rather E. This is what the paper says we should use.
    tainted_ether = Ether(dst='ff:ff:ff:ff:ff:fe') / arp_detect
    return tainted_ether
    

if __name__ == "__main__":
    main()