; File: exit.nasm
; Author: Kevin Ren, Originally Professor Viviek of SLAE
; Purpose: to demostrate an exit shellcode without any nullbytes in opcode


global _start
_start: 	
	xor eax, eax				; xor zeros out all the bits in the given register
	mov al, 1				; this is equalivalent to mov eax, 1, but without all the nullbytes to pad fill 
						; the eax register after 1 is stored in the first byte --> al
	xor ebx, ebx				; same goes for ebx
	mov bl, 10				; given an exit status of 10 for testing purpose
	
	int 0x80				; invoke sys call exit
