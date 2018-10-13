; File: stack.nasm
; Author: Kevin Ren, originally professor Viviek
; Purpose: to demostrate stack operations

global _start

section .text
_start:
	mov rax, 0x1122334455667788
	push rax

	push sample

	push qword [sample]
	
	pop r15
	pop r14
	pop rbp

	; exit the program gracefully
	mov rax, 60					; or 0x3c in hex
	mov rdi, 0
	syscall


section .data
	sample: db 0xaa,0xbb,0xcc,0xdd,0xee,0xff,0x11,0x22
	

	
