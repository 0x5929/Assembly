; File: endianess.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: print hello world onto the screen using basic assemblyx86_64 and exits gracefully and to demostrate little endianess

; SYSCALL NEEDED:
;			1. #1 write
;			2. #60 exit 



global _start				; entry point

section .text
_start:					; entry point memory label
	; print to screen
	mov rax, 0x1			; syscall number
	mov rdi, 0x1			; first arg, fd: 1 for standard output
	mov rsi, msg			; second arg, message to output
	mov rdx, msg_len		; third arg, length of message
	syscall				; invoking syscall vs int 0x80 in x86 assembly

	mov rax, [var1]			; moving value of var1 into rax
	mov rbx, [var2]			; moving the reverse value of var1 into rbx

	; exit gracefuly
	mov rax, 60			; syscall number for exit
	mov rdi, 0xa			; return status number to be 10, for testing purpose
	syscall				; invoking syscall 




section .data
	msg: db "Hello, World!", 0xa	; message to be outputted
	msg_len equ $ - msg		; message length, using equate and $ (current line) minus msg memory, which will give us len of msg
	
	var1 : db 0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88
	var2 : db 0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11
