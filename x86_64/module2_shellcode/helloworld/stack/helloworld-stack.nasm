; File: helloworld-stack.nasm
; Author: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: print hello world onto the screen using basic assemblyx86_64 and exits gracefully
; 	  get rid of all 0x00 opcode instructions
; 	  no hardcoded address, b/c not all victim systems have the same hardcoded memory in their exploits
;	  using stack technique 


; SYSCALL NEEDED:
;			1. #1 write
;			2. #60 exit 



global _start				; entry point

section .text
_start:					; entry point memory label

	xor rax, rax			; zeroing out all registers needed
	xor rdi, rdi
	xor rdx, rdx

	; NOTE: WE CANNOT PUSH A IMM64 ONTO THE STACK
	; WE CAN, HOWEVER, MOV IMM64 TO REG, AND PUSH REG
	
	mov rbx, 0x21646c726f57202c	; pushing helloooo, world! in reverse hex onto the stack, and using the top of stack as a address 
	push rbx
	mov rcx, 0x6f6f6f6f6c6c6568	; for the second argument in the write syscall, could have also had msg not a factor of 8, it requires
	push rcx			; more work with the stack in zeroing out unnessaary bits

	; print to screen
	mov al, 0x1			; syscall number
	mov dil, 0x1			; first arg, fd: 1 for standard output
	mov rsi, rsp			; second arg, by referecing top of stack, which as hello world in reverse hex
	mov dl, 16			; third arg, length of message
	syscall				; invoking syscall vs int 0x80 in x86 assembly


	; exit gracefuly
	mov al, 60			; syscall number for exit
	mov dil, 0xa			; return status number to be 10, for testing purpose
	syscall				; invoking syscall 

	




