#!/usr/bin/env python3
import os
import sys

# Check if the user has provided the input directory as a command-line argument
if len(sys.argv) < 2:
    print("Usage: python3 replace_first_10_bytes.py <input_dir>")
    sys.exit(1)

input_dir = sys.argv[1]  # First command-line argument is the input directory
# replacement_bytes = bytes.fromhex('09010002000000000031')
replacement_bytes = bytes.fromhex('')

# Check if the input directory exists
if not os.path.exists(input_dir):
    print(f"Error: Directory {input_dir} does not exist.")
    sys.exit(1)

# Get a list of all binary files in the directory
files = [f for f in os.listdir(input_dir) if f.endswith('.bin')]

for file in files:
    input_path = os.path.join(input_dir, file)
    
    # Read the binary file
    with open(input_path, 'rb') as f:
        data = f.read()
    
    # Replace the first 10 bytes with the specified replacement bytes
    if len(data) > 10:
        data = replacement_bytes + data[10:]
    else:
        data = replacement_bytes[:len(data)] + data[10:]
        
    # Write the modified data back to the file
    with open(input_path, 'wb') as f:
        f.write(data)
        
print("Finished processing all files.")

