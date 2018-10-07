; File: procedure.nasm
; Author: Kevin Ren, originally professor Viviek from SLAE64
; Purpose: to demostrate procedure implementation in asm64, using call and ret 


global _start

section .text

outputHelloWorld:
	push rbp				; set stack marker
	mov rbp, rsp

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, msg
	mov rdx, len
	syscall

	leave					; retore stack, equ mov rsp, rbp; pop rbp 
	ret					; pop stack to rip

	
_start: 
	mov rcx, 0x5

printHelloWorld:
	push rcx				; preserve counter
	call outputHelloWorld			; stdout, and pushes next instruction's location onto the stack

	pop rcx					; restore counter
	loop printHelloWorld

exitGracefully:
	mov rax, 0x3c				; exit syscall
	mov rdi, 0
	syscall		


section .data
	msg: db "Hello, world!", 0xa
	len equ $ - msg
