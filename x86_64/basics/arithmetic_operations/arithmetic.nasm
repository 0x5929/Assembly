; File: arithmetic.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: to demostrate the use of arithmetic operations




global _start

section .text
_start:
	; register based addition
	mov rax, 0x1
	add rax, 0x1
	
	mov rax, 0xffffffffffffffff			; all bits turned on
	add rax, 0x1					; this will result of overflow/carry?
	
	; register based subtration
	mov rax, 0x9
	sub rax, 0x1

	; memory based addition
	mov rax, qword [var1]
	add qword [var4], rax
	add qword [var4], 0x2

	; set clear/ complement(make opposite) carry flag
	clc
	stc	
	cmc

	; add with carry
	mov rax, 0
	stc
	adc rax, 0x1					; results in 0x2
	stc
	adc rax, 0x2					; results in 5

	; subtract with borrow
	mov rax, 0x10					; 16 in decimal
	sub rax, 0x5					; results in 11 in decimal
	stc						; set carry flag
	sbb rax, 0x4					; 11-1-4 = 0x6

	; increment and decrement
	inc rax						; increments by 1
	dec rax						; decrements by 1

	; exit the program
	mov rax, 0x3c
	mov rdi, 0
	syscall

section .data
	var1: dq 0x1
	var2: dq 0x1122334455667788
	var3: dq 0xffffffffffffffff	
	var4: dq 0x0





