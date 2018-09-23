#include <stdio.h>
#include <string.h>

/**
	REMEMBER THAT SHELLCODE FROM ONLINE IS NEVER TRUSTED, 
	ALWAYS RUN IT IN A VIRTUAL ENVIRONMENT AND NOT YOUR ACTUAL MACHINE
	AKA A TESTING SANDBOX 
*/

unsigned char code[] = \
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69"
"\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";


int main(int argc, char** argv)
{
	printf("Shellcode Length: %d\n", strlen(code));
	
	// define a pointer to a type int function name ret, and it takes no arguments
	// initialize it to a type int function pointer that takes no arguments casted on shellcode

	int (*ret)() = (int(*)())code;

	// running the pointer function
	ret();

	return 0;
}
