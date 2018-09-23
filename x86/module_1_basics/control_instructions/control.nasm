; File: control.nasm
; Author: Kevin Ren, oringally from Professor Vievik of SLAE



; Purpose: to illustrate control instructions such as jmp, or conditional jumps on GDB



global _start

section .text
_start:
	jmp Begin

NeverExecute:				; these memory lines are never going to be executed because after _start we jmp to Begin
	mov eax, 0x10
	xor ebx, ebx

Begin: 
	mov eax, 0x5			; the start of operations, first moving 0x5 into eax


PrintHW:
	push eax			; pushing eax value onto the stack, which is 0x5, so eax can be used in syscall
	
	mov eax, 0x4			; printing hello world using system call number 4
	mov ebx, 1			; using fd 1 for stdout
	mov ecx, message		; defined in data, the hello world string
	mov edx, m_len			; also defined in data
	int 0x80			; syscall invocation

	pop eax				; popping the top of stack back into eax, should be 0x5 right now
	dec eax				; decrements counter, and will set zf if eax is 0
	jnz PrintHW			; this will loop back to the PrintHW memory label, note jne is same as jnz in intel manual
	
	
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80			; gracefully exits using sys_exit syscall

section .data

	message: db "Hello World!", 0xa
	m_len	equ	$-message	; m_len equals to current line of memory minus message memory label  
