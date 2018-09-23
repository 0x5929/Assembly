; File: logical.nasm
; Author: Kevin Ren, originally from professor Vivek of SLAE
; Purpose: to illustrate logical instructions such as and, or, xor, shl, sal, ror, rcr, on GDB


global _start

section .text
_start: 
	; AND usage
	mov al, 10101010b
	and al, 11111111b			; 10101010 and 111111111 = 10101010

	and byte [var1], 00001111b		; 11110000 and 00001111 = 00000000, overwrites the label
	and word [var2], 0x1122			; hex needs to be converted to binary before operation

	
	; OR usage
	mov al, 01010101b			
	or al, 11111111b			; 01010101 or 11111111 = 11111111

	or byte [var1], 00000000b		; 00000000 or 00000000 = 00000000

	mov eax, 0
	or eax, 0x0				; 0 or 0 = 0

	
	; XOR usage (exclusive or)
	mov al, 10010011b
	xor al, 11111111b			; 10010011 xor 11111111 = 01101100 

	xor dword [var3], 0x11223344
	xor dword [var3], 0x11223344		; should return original [var3]


	; NOT usage
	mov eax, 0xFFFFFFFF
	not eax
	not eax					; should return 0xFFFFFFFF

	
	; SHL, SHR usage
	mov bl, 01010101b
	shl bl, 3				; 01010101 logical shifts left 3 times = 10101000, CF off

	mov bl, 01010101b
	shr bl, 3				; 01010101 logical shifts right 3 times = 00001010, CF on


	; SAL, SAR usage
	mov bl, 10101010b
	sal bl, 3				; 10101010 arithmetic shifts left 3 times = 01010000. CF on

	mov bl, 10101010b
	sar bl, 3				; 10101010 arithmetic shifts right 3 times = 11110101, CF off


	; ROL, ROR usage
	mov bl, 00001111b
	rol bl, 3				; 00001111 logical rotates left 3 times = 01111000, CF off
	
	mov bl, 00001111b
	ror bl, 3				; 00001111 logical rotates right 3 times = 11100001, CF on


	; RCL, RCR usage
	clc					; clearing carry flag first
	mov bl, 10010011b
	rcl bl, 3				; 10010011 with carry rotates left 3 times = 11011010, CF off

	clc
	mov bl, 10010011b
	rcr bl, 3				; 10010011 with cary rotates right 3 times = 11010010, CF off


	; system exit
	mov eax, 1
	mov ebx, 0
	int 0x80


section .data
	var1: db 11110000b
	var2: dw 0xbbcc
	var3: dd 0x11223344
