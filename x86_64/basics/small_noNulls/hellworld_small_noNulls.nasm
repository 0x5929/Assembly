; File: helloworld.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: print hello world onto the screen using basic assemblyx86_64 and exits gracefully
; 		Also reducing size by using the appropriate size destiantion registers during mov operations
;		and removing nulls by xoring/zeroing out the registers before usage

; SYSCALL NEEDED:
;			1. #1 write
;			2. #60 exit 



global _start				; entry point

section .text
_start:					; entry point memory label
	; print to screen
	xor rax, rax
	mov al, 0x1			; syscall number, trying to reduce size by moving only into al, only have 2 bytes vs 8 before
	
	xor rdi, rdi
	mov dil, 0x1			; first arg, fd: 1 for standard output

	xor rsi, rsi
	mov rsi, msg			; second arg, message to output

	xor rdi, rdi
	mov dl, msg_len		; third arg, length of message
	syscall				; invoking syscall vs int 0x80 in x86 assembly


	; exit gracefuly
	mov al, 60			; syscall number for exit
	mov dil, 0xa			; return status number to be 10, for testing purpose
	syscall				; invoking syscall 




section .data
	msg: db "Hello, World!", 0xa	; message to be outputted
	msg_len equ $ - msg		; message length, using equate and $ (current line) minus msg memory, which will give us len of msg
