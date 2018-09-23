; file: helloWorldStack.nasm
; Author: Kevin Ren, originally Professor Viviek from SLAE
; Purpose: to demostrate a hello world shellcode using the stack technique

; OBJECTIVE:
;		1. We need to get a reference of the printed string in memory dynamically
;		2. we can push the actual string onto the stack in reverse order
;		3. referencing the top of stack at esp can reference our entire null terminated string



global _start


section .text
_start:

	xor eax, eax				; zeroing out eax for sys call number 4 to avoid nullbyte instructions
	mov al, 0x4

	xor ebx, ebx				; zeroing out ebx, but now using number 1 as standard output file descriptor
	mov bl, 0x1

	xor edx, edx				; zeroing out edx for null terminater to be pushed onto the stack
	push edx				; starting the reverse push

						; REMEMBER: this particular system is little endian, meaning lowest bit goes to lowest memory
						; perfect in our case, padding the last extra byte in the lowest byte of zeroed out register 
						; at the end of string
						; this way when referenced, the rest of padding is zero, then null term pushed before this	
	mov dl, 0x0a				; pads the last part of the string we want with zeroed out edx register
	push edx				; pushes it onto the stack 

	
	push 0x21212164
	push 0x6c726f57
	push 0x202c6f6c
	push 0x6c6c6548				; pushes "Helllo, World!!!\n" onto the stack in reverse
	

	mov ecx, esp				; moved esp address that references the string we want into ecx param register
	
	xor edx, edx				; zeroing out edx to put length of string we need for sys call param
	mov dl, 17				; 17 is the length of string we want to print
	
	int 0x80				; syscall

	
	xor eax, eax
	mov al, 0x1
	
	xor ebx, ebx
	int 0x80				; exit syscall


