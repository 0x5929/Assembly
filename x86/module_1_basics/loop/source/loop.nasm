; File: control.nasm
; Author: Kevin Ren, oringally from Professor Vievik of SLAE



; Purpose: to illustrate the loop instructions such as loop, or loopz, loopnz, on GDB

; loop instruction will jump/loop to a label on ecx condition, and it automacticly dec ecx/counter register
; loopz and loopnz insturction will stop jump/loop if zero flag is either set or not set before ecx reaches 0


; demostrating loop


global _start

section .text
_start:
	jmp Begin

NeverExecute:				; these memory lines are never going to be executed because after _start we jmp to Begin
	mov eax, 0x10
	xor ebx, ebx

Begin: 
	mov ecx, 0x5			; the start of operations, first moving 0x5 into counter register, ecx


PrintHW:
	push ecx			; pushing ecx value onto the stack, which is 0x5, so ecx can be used in syscall
	
	mov eax, 0x4			; printing hello world using system call number 4
	mov ebx, 1			; using fd 1 for stdout
	mov ecx, message		; defined in data, the hello world string
	mov edx, m_len			; also defined in data
	int 0x80			; syscall invocation

	pop ecx				; popping the top of stack back into ecx, should be also manipulated by loop instruction to dec
	loop PrintHW			; this will loop back to the PrintHW memory label, until ecx is 0 
	
	
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80			; gracefully exits using sys_exit syscall

section .data

	message: db "Hello World!", 0xa
	m_len	equ	$-message	; m_len equals to current line of memory minus message memory label  
