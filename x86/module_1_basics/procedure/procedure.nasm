; File: procedure.nasm
; Author: Kevin Ren, Originally from professor viviek of SLAE
; Purpose: to demostrate procedure calling and set up in assembly


global _start

section .text

HelloWorldProc:			; procedure defined here so it doesn't get accidentally invoked
	
	push ebp		; setting the stack frame pointer, so we can preserve the stack during procedure calls
	mov ebp, esp		; setting the current stackpointer location into ebp register

	mov eax, 0x4		; printing message/hello world using syscall
	mov ebx, 0x1
	mov ecx, message
	mov edx, mlen
	int 0x80

	;mov esp, ebp		; clean up code/retore stack pointer to what was before, same as leave instruction
	;pop ebp
	
	leave
	ret			; end of procedure, pops the instruction after call from stack into eip


_start:				; program entry point

	mov ecx, 0x5		; setting coutner to 5


PrintHelloWorld:		; what we need to loop

	pushad			; preserving all registers and flags onto the stack before function call
	pushfd

	call HelloWorldProc	; calling hello world procedure, pushes next instructions address from eip onto the stack
	
	popfd			; restoring all registers and flags from the stack back to our registers
	popad

	loop PrintHelloWorld	; loops PrintHelloWorld Label


Exit:				; system call, exits program	
	mov eax, 0x1		; gracefully exits if we are done looping
	mov ebx, 0x0
	int 0x80		



section .data

message: 	db "Hello, world!", 0xa
mlen 		equ $ - message
