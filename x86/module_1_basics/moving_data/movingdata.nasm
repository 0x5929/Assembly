; Filename: movingdata.nasm
; Author: Kevin Ren
; Date: 08-22-2018


; Purpose: to illustrate data movement in assembly for instruction mov, lea, xchg

; defining global entry point for linker
global _start

section .text
_start: 

	; moving immediate data to register
	; REMEMBER: mov uses the source/second operand's value, and if operand is a variable such as register or [varibale_address] 
	; 		it shall evaluate that first, and copies it into
	; 		into the dest/first operand, and the dest/first operand HAVE TO be a variable such as register or [variable_address]
	; 		similar to C: int *variable_address = &variable and de-referencing *variable_address = variable itself

	mov eax, 0xaaaaaaaa
	mov al, 0xbb
	mov ah, 0xcc
	mov ax, 0xdddd

	mov ebx, 0
	mov ecx, 0

	
	; moving register to register

	mov ebx, eax
	mov cl, al
	mov ch, ah
	mov cx, ax
	
	mov eax, 0
	mov ebx, 0
	mov ecx, 0

	
	; moving from memory into register
	
	mov al, [sample]
	mov ah, [sample+1]
	mov bx, [sample]
	mov ecx, [sample]

	
	; moving from register into memory
	
	mov eax, 0x33445566
	mov byte [sample], al
	mov word [sample], ax
	mov dword [sample], eax


	; moving immediate value into memory

	mov dword [sample], 0x33445566


	; lea demo
	; REMEMBER: lea instruction source operand [mem] is not evaluated/de-referenced
	; 		the square brackets are only for syntax/consistency purposes
	; 		the address/value at register (may or maynot be an address) inside the brackets are stored in dest operand

	lea eax, [sample]
	lea ebx, [eax]

	
	; xchg demo
	mov eax, 0x11223344
	mov ebx, 0xaabbccdd

	xchg eax, ebx
	; i assume register and mem looks like this
	; xchg eax, [label]

	; exit the program gracefully

	mov eax, 1
	mov ebx, 0
	int 0x80

section .data

	sample: db 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x11, 0x22
	




section .data
