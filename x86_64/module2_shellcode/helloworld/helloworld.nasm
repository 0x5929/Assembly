; File: helloworld.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: print hello world onto the screen using basic assemblyx86_64 and exits gracefully
; 	  get rid of all 0x00 opcode instructions
; 	  no hardcoded address, b/c not all victim systems have the same hardcoded memory in their exploits
;	  using jmp call pop technique


; SYSCALL NEEDED:
;			1. #1 write
;			2. #60 exit 



global _start				; entry point

section .text
_start:					; entry point memory label
	jmp short call_shellcode	; jmp short to call_shellcode label

shellcode:
	xor rax, rax			; zeroing out all registers needed
	xor rdi, rdi
	xor rdx, rdx

	; print to screen
	mov al, 0x1			; syscall number
	mov dil, 0x1			; first arg, fd: 1 for standard output
	pop rsi				; second arg, message got from the top of stack from call in call_shellcode
	mov dl, 14			; third arg, length of message
	syscall				; invoking syscall vs int 0x80 in x86 assembly


	; exit gracefuly
	mov al, 60			; syscall number for exit
	mov dil, 0xa			; return status number to be 10, for testing purpose
	syscall				; invoking syscall 

call_shellcode:
	call shellcode			; pushes msg label address to the stack
	msg: db "Hello, World!", 0xa	; message to be outputted
	




