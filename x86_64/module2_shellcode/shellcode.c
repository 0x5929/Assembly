#include <stdio.h>
#include <string.h>

/**
	REMEMBER THAT SHELLCODE FROM ONLINE IS NEVER TRUSTED, 
	ALWAYS RUN IT IN A VIRTUAL ENVIRONMENT AND NOT YOUR ACTUAL MACHINE
	AKA A TESTING SANDBOX 
*/

unsigned char code[] = \
"\x48\x89\xd8\x48\x29\xd8\x48\x31\xdb\xb0\x3b\x48\x89\x5c\x24\xf8\x48\x83\xec\x08\x48\xb9\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x51\x48\x89\xe7\x48\x89\x5c\x24\xf8\x48\x89\x7c\x24\xf0\x48\x83\xec\x10\x48\x89\xe6\x53\x48\x89\xe2\x0f\x05";


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
