; File: helloworld_relative.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: to demostrate rip relative addressing in shellcoding
; NOTE: this can only apply to 64 bit mode ONLY



global _start
;default rel				; same as doing lea rsi, [rel msg], but instead its: lea rsi, [msg]
					; the other way is better, b/c this way probably sets all addressing computation to relative to rip
					; if neither is used, then absolute/hardcoded address computation will apply to lea rsi, [msg]
section .text
_start: 
	jmp begin_execute		; this makes sure that string is defined before rip for a negative address which flips 0s to Fs
	msg: db "hello, world!", 0xa


begin_execute:
	; zeroing out registers
	xor rax, rax
	xor rdi, rdi
	xor rdx, rdx

	; write to stdout
	mov al, 1
	mov dil, 1
	lea rsi, [rel msg]		; loading relative address computation of msg into rsi, but this gives 00 bytes because msg
					; is defined after and its automatically padded with nulls if needed by the assembler 
					; to fix this problem, we need to do the following: define the label before the current rip
					; so all 0s can be Fs (bit flipped to 1 for the negative sign)
	mov dl, 14
	syscall

	; exit
	mov al, 60
	xor rdi, rdi
	syscall

