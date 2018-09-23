; File: multidiv.nasm
; Author: Kevin Ren, originally from Prof Viviek of SLAE
; Purpose: to illustrate mul imul, div idiv instructions


global _start

section .text
_start: 

	; unsign r/m8 mulitplication
	
	mov al, 0x10
	mov bl, 0x2
	mul bl					; stored in ah:al
	
	mov al, 0xFF
	mul bl					; stored in ah:al


	; unsigned r/m16 multiplication
	
	mov eax, 0x0			
	mov ebx, 0x0

	mov ax, 0x1122
	mov bx, 0x0022
	mul bx					; stored in dx:ax

	mov ax, 0x1122
	mov bx, 0x1122
	mul bx					; stored in dx:ax

	
	; unsigned r/m32 multiplication

	mov eax, 0x11223344
	mov ebx, 0x00000002
	mul ebx					; stroed edx:eax

	mov eax, 0x11223344
	mov ebx, 0x55667788
	mul ebx					; stored edx:eax

	
	; multiplication using memory location
	
	mul byte [var1]				; stored ah:al
	mul word [var2]				; stored dx:ax
	mul dword [var3]			; stored edx:eax

	; division using r/m16
	
	mov dx, 0x0
	mov ax, 0x7788
	mov cx, 0x2
	div cx					; Q-> ax, R-> dx

	mov ax, 0x7788 + 0x1
	mov cx, 0x2
	div cx					; Q->ax, R-> dx

	
	; signed muliplication using imul instruction
		; one operand scenario
	mov eax, 0x11223344
	mov ebx, 0x11223344
	imul ebx				; stored in edx:eax

		; two operand scenario
	imul edx, 2				; stored in edx	(make sure enough size in dest operand)		
	imul ebx, [var1] 			; stored in ebx
	

		; three operand scenario
	imul ecx, [var3], 0x2			; stored in ecx, make sure enough size in dest operand, usually 2x source operands	



	; signed division using idiv instruction 
		; 8 bit division
	mov ax, 0x0022		
	mov bl, 0x2
	idiv bl					; Q-> al, R-> ah

		; 16 bit division
	mov ax, 0x2222
	mov dx, 0x0000
	mov bx, 0x2
	idiv bx					; Q-> ax, R-> dx

		; 32 bit division
	mov eax, 0x44444444
	mov edx, 0x00000000
	mov ebx, 0x22222222
	idiv ebx 				; Q-> eax, R-> edx


	; exit program
	mov eax, 1
	mov ebx, 0
	int 0x80


section .data
	
	var1: db 0x05
	var2: dw 0x1122
	var3: dd 0x11223344

