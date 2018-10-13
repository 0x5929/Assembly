; File: bitshifting.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: to demostrate bit shifting operations, shift left/right, shift arithmetic left/right 

global _start

section .text
_start:
	
	mov rax, 0x00000000ffffffff
	sal rax, 32
	sal rax, 1

	clc
	mov rax, 0x00000000ffffffff
	shr rax, 1
	shr rax, 31

	clc
	mov rax, 0x00000000ffffffff
	sar rax, 1
	clc
	mov rax, 0xffffffffffffffff
	sar rax, 1

	clc
	mov rax, 0x0123456789abcdef
	ror rax, 8
	ror rax, 12
	ror rax, 44

	; exit 
	xor rax, rax
	mov rax, 0x3c
	mov rdi, 0x0
	syscall

	
	
