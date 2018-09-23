; File: stack.nasm
; Author: Kevin Ren

; Purpose: to demostrate stack manipulation when run with gdb



global _start

section .text

_start:

	; moving some values into registers

	mov eax, 0x66778899
	mov ebx, 0x0
	mov ecx, 0x0

	; push and pop of r/m16 (16 bit data) and r/m32 (32 bit data)
	
	; register push and pop
	push ax
	pop bx

	push eax
	pop ecx


	; memory push and pop
	; we pop data back into registers to examine as well

	push word [sample]
	pop ecx

	push dword [sample]
	pop edx


	; pushad and popad demo, (push all double, or pop all double) 
	; must have data in esi and edi register to be able to visualize at the top of stack, because they are the last registers
	; to get pushed

	mov esi, 0x11223344
	mov edi, 0xaabbccdd

	pushad
	popad

	; exit the program gracefully
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80



section .data

	sample: db 0xaa, 0xbb, 0xcc, 0xdd, 0x11, 0x22, 0x33, 0x44




