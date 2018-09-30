; Testing command line arguments on the stack



; stack when binary is executed: 

; High Memory ==> | emtpy | 4 Null Bytes | nth environment variable | address of environment variable 1 | 4 Null Bytes | nth address of last arg
; 		  | Address of Arg 1 | Address of program Path | argument count [esp] | ==> Low Memory


global _start


section .text
_start:
	add esp, 4			; so we ignore the argument count
	
	pop dword [program_path]
	mov ecx, [program_path]
	call strlen
	call print	

	pop dword [first_arg]	
	mov ecx, [first_arg]
	call strlen
	call print	
	
	pop dword [second_arg]
	mov ecx, [second_arg]
	call strlen
	call print	

	; exit
	mov eax, 0x1
	mov ebx, 0x5
	int 0x80	

strlen:
	push ebp
	mov ebp, esp

	push ecx			; store this in the top of the stack
	mov edx, 0
	dec ecx				; so we can start by evaluating the first character
	
	count:
		inc edx
		inc ecx 
		cmp byte [ecx], 0	; compare it with null
		jnz count

	dec edx				; account for the inc from inside the loop
	pop ecx				; pop the top of stack back into ecx for pointer address of string 


	leave
	ret

print:					; NOTE ecx should already have the address of string that needs to be printed
					; and edx should already have the length of the string that needs to be printed
	push ebp
	mov ebp, esp
	
	mov eax, 0x4
	mov ebx, 0x1

	int 0x80


	leave
	ret



section .bss
	; NOTE THE ARGC IS NOT PRINTED, CUZ ITS TOO CRAZY TO CONVERT HEX INTO DECIMAL, and really no point
	program_path: resb 4		; reserve 4 bytes for dword of pointer address of program path
	first_arg: resb 4		; reserve 4 bytes for dword of pointer address of first argument
	second_arg: resb 4		; reserve 4 bytes for dword of pointer address of second argument
