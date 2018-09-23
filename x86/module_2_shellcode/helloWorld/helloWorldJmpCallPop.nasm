; File: helloWorldJmpCallPop.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE
; Purpose: to demostrate a helloworld shellcode with dynamic data address using jmp short, call and pop technique


global _start


section .text
_start:
	jmp short call_shellcode			; remember jmp short is only for -127 to +128 memory offset jumps

shellcode:
	xor eax, eax					; sys call write, using xor to zero out bits and to avoid 00 nullbytes
	mov al, 0x4
	
	xor ebx, ebx			
	mov bl, 0x1
	
	pop ecx						; the address of message is popped from stack to ecx register (exactly what we want)

	xor edx, edx					; this might be the only downside, the need to hard code message length
	mov dl, 14
	int 0x80

	
	xor eax, eax					; sys call exit
	mov al, 0x1
	
	xor ebx ebx	
	int 0x80
	
call_shellcode:
	call shellcode					; the call instruction will push the next instruction memory to the stack
	message	: db "Hello, World!", 0xa		; usually the memory will be popped to eip after ret instruction is issued
							; within the procedure
