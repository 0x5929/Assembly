; File: libc.nasm
; Author: Kevin Ren, originally professor viviek of SLAE
; Purpose: demostrating the usage of libc functions in assembly x86

; extern keyword means the following function is defined in another object file, 
; the libc library object file in this case, also linked by the linker


extern printf
extern exit


; linking libc requires using gcc linker
; which takes entry point at main

global main


section .text
main:	
	push message		; in order to use functions in libc, we need to push the arguments in reverse order onto the stack before calling
	call printf		; actual libc function invocation
	add esp, 0x4		; re-adjusting the stack, moving the stack back 4 bytes, essentially popping message without storing it in reg 

	push 0x0
	call exit
	


section .data
	message: 	db "Hello World!", 0xA, 0x00		; null terminator is required for libc function that deals with strings
	mlen		equ $ - message
