; File: logical.nasm
; Author: Kevin Ren, originally professor viviek from SLAE64
; Purpose: to demostrate logical operations: NOT, AND, OR, XOR

global _start

section .text
_start:
	; NOT Operation
	mov rax, qword [var2]
	not rax					; not var2

	mov rbx, qword [var1]
	not rbx					; not var1

	; AND operation
	mov rax, qword [var2]
	mov rbx, qword [var1]
	and rbx, rax				; var1 and var2

	mov rbx, qword [var1]			
	and rbx, qword [var1]			; var1 and var1

	; OR operation
	mov rax, qword [var2]
	mov rbx, qword [var1]
	or rbx, rax				; var1 or var2

	mov rbx, qword [var1]
	or rbx, qword [var1]			; var1 or var1

	; XOR operation
	mov rax, 0x0101010101010101
	mov rbx, 0x1010101010101010
	xor rax, rbx				; should result in 0x1111111111111111

	xor rax, rax				; should result in 0
	
	xor qword [var1], rax		

	
	; exit program
	mov rax, 0x3c
	mov rdi, 0
	syscall

section .data
	
	var1: dq 0x1111111111111111
	var2: dq 0x0
