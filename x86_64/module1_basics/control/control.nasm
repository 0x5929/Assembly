; File: control.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE 64
; Purpose: to demostrate conditional/unconditional control branching 



global _start

section .text
_start:
	jmp Begin

Never_execute:
	; exit syscall
	mov rax, 0x3c
	mov rdi, 10			; this will not be the exit status number
	syscall

Begin: 
	mov rax, 0x5

PrintHW:
	; maintain state
	push rax

	; print to screen
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, msg_len
	syscall
	
	; restore state
	pop rax
	dec rax
	jnz PrintHW	

	; exit syscall
	mov rax, 0x3c
	mov rdi, 0
	syscall


section .data
	msg: db "Hello! WOrld!", 0xa
	msg_len equ $ - msg	
