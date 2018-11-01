#!/usr/bin/python


# future improvements:
#			allocate a page in memory with rwx privs using ctypes
#			allocate buffer for decrypted shellcode
#			copies decrypted shellcode into newly allocated memory
#			execute the shellcode now in memory

from __future__ import print_function
import sys

# globals
MAX_ARRAY_LEN = 256
keystream = []
rc4_i = None
rc4_j = None
encrypted_shellcode = (\
"\x34\xfb\x93\x8f\xe0\xea\x19\x3b\x6a\xb3\xf0\x7d\xa9\x7a\x16\x05\x83\xfe\xa1\x02\x87\x01\x1f\x48\x53\x52\x5a\x40\x2f\x76\xd1\xe5\xbe\x58\x9e\xb2\x01\x0b\x55\x64\xbb\x0e\x55\x03\x0b\xa1\x97\x8b\x6f\xb5\x38\x31\xfc")


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
