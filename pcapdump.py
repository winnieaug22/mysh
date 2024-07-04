#!/usr/bin/env python3
import sys
import subprocess
import os

# Check if the user has provided the pcap file name as a command-line argument
if len(sys.argv) < 2:
    print("Usage: python3 pcapdump.py <pcap_file>")
    sys.exit(1)

pcap_file = sys.argv[1]  # First command-line argument is the pcap file name
output_dir = "merged_packets"
os.makedirs(output_dir, exist_ok=True)

# Capture eth.dst, eth.src, eth.type, and data.data fields
process = subprocess.Popen(["tshark", "-r", pcap_file, "-T", "fields",
                            "-e", "eth.dst", "-e", "eth.src", "-e", "eth.type", "-e", "data.data"],
                           stdout=subprocess.PIPE,
                           universal_newlines=True)

packet_number = 0

for line in iter(process.stdout.readline, ''):
    if line.strip():  # Non-empty line indicates packet data
        packet_number += 1
        output_file = os.path.join(output_dir, f"packet_{packet_number}.bin")
        # Split the line into eth.dst, eth.src, eth.type, and data.data
        parts = line.strip().split("\t")
        eth_dst = parts[0].replace(":", "")  # Remove colons from MAC address
        eth_src = parts[1].replace(":", "")  # Remove colons from MAC address
        eth_type = parts[2].strip()  # Remove leading/trailing spaces
        data = parts[3].replace(" ", "")  # Remove spaces from data.data

        # Combine fields into a single binary packet
        merged_packet = bytes.fromhex(eth_dst + eth_src + eth_type[2:] + data)  # eth.type without "0x"
        with open(output_file, "wb") as f:
            f.write(merged_packet)

process.stdout.close()
process.wait()

print(f"Exported {packet_number} merged packets to {output_dir}")

