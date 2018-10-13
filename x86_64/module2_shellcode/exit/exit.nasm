; File: exit.nasm
; Author: Kevin Ren, originally professor Viviek from SLAE64
; Purpose: to demostrate asm 64 shellcode executing exit sys call
; 	   without use of Null Bytes, and as compact as possible


global _start

section .text
_start:
	xor rax, rax			; zeroing out registers, so they use zero instead of Null
	xor rdi, rdi			; rdi, return value is 0

	mov al, 0x3c			; exit syscall
	syscall
