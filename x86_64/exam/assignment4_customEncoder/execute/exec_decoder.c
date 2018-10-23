#include <stdio.h>
#include <string.h>

/**
	REMEMBER THAT SHELLCODE FROM ONLINE IS NEVER TRUSTED, 
	ALWAYS RUN IT IN A VIRTUAL ENVIRONMENT AND NOT YOUR ACTUAL MACHINE
	AKA A TESTING SANDBOX 
*/

unsigned char code[] = \
"\xeb\x23\x59\x20\xd1\x59\x20\xca\xa1\x2a\x42\x59\xa8\x3e\x73\x78\x7f\x3e\x3e\x62\x79\x40\x59\x98\xf6\x42\x46\x59\x98\xf7\x42\x59\x98\xf3\x1e\x14\xbb\x48\x8d\x35\xd6\xff\xff\xff\x80\x36\xbb\x74\xd1\x80\x36\xaa\x48\xff\xc6\xeb\xf3";

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
