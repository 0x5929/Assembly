; File: datatypes.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: print hello world onto the screen using basic assemblyx86_64 and exits gracefully, and to illustrate fundamental data types in asm64

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
	
	mov rax, var4			; showing address, and dereferencing
	mov rax, [var4]

	; exit gracefuly
	mov rax, 60			; syscall number for exit
	mov rdi, 0xa			; return status number to be 10, for testing purpose
	syscall				; invoking syscall 




section .data
	msg: db "Hello, World!", 0xa	; message to be outputted
	msg_len equ $ - msg		; message length, using equate and $ (current line) minus msg memory, which will give us len of msg

	var1 : db 0x11, 0x22
	var2 : dw 0x3344
	var3 : dd 0xaabbccdd
	var4 : dq 0xaabbccdd11223344

	repeat_buffer: times 128 db 0xAA

section .bss
	buffer: resb 64
