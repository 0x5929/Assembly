; File: loop.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE 64
; Purpose: to demostrate conditional/unconditional loops



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
	mov rcx, 0x5

PrintHW:
	; preserve rcx, in case syscall tempers with it
	push rcx

	; print to screen
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, msg_len
	syscall				; the value of rcx changes during the syscall, thats why we need to preserve rcx while loop
	
	; retstore rcx
	pop rcx
	loop PrintHW			; dec rcx, and jmp PrintHW when rcx > 0
	
	
	; exit syscall
	mov rax, 0x3c
	mov rdi, 0
	syscall


section .data
	msg: db "Hello! WOrld!", 0xa
	msg_len equ $ - msg	
