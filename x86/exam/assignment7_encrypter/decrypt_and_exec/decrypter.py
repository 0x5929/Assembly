#!/usr/bin/python

from __future__ import print_function
import sys

# globals
MAX_ARRAY_LEN = 256
keystream = []
rc4_i = None
rc4_j = None
encrypted_shellcode = (\
"\xee\x30\x9d\x67\xb8\x6f\x1e\x59\x4a\x63\x19\xf4\x36\x1b\x05\xaa\xf5\xe3\x10\x10\x0c\x53\x8f\xf4\xc9")

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
	
	for byte in bytearray(encrypted_shellcode):			# byte references each element of the array
		
		keystream_byte = RC4_PRNG()
		
		decrypted_byte = byte ^ keystream_byte

		print("\\x%02x" %decrypted_byte, end="")
		

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
