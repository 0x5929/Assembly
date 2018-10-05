; File: movingData.nasm
; Author: Kevin Ren, originally professor Viviek
; Purpose: to demostrate mov instructions in 64-bit CPU

global _start

section .text
_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; mov immediate data to register
	mov rax, 0xaaaaaaaabbbbbbbb
	mov eax, 0xaaaaaaaa
	
	mov rax, 0xaaaaaaaabbbbbbbb
	mov al, 0x11
	
	mov rax, 0xaaaaaaaabbbbbbbb
	mov ah, 0xcc
	
	mov rax, 0xaaaaaaaabbbbbbbb
	mov ax, 0xdddd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; mov register to register
	mov rbp, rax
	mov r10, rbp

	mov r11d, r10d
	mov r12w, r11w
	mov r13b, r12b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;mov memory to register
	mov rsi, [sample2]
	mov r14d, [sample]
	mov r15w, [sample]
	mov dil, [sample]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; mov register into memory
	mov rax, [sample2]
	mov byte [sample], al
	mov word [sample], ax
	mov dword [sample],eax
	mov qword [sample],rax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; lea demo
	lea rax, [sample]
	lea rbx, [rax]					; what will this result in?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; xchg demo
	mov rax, 0x1234567890abcdef
	mov rbx, 0x7777777777777777
	
	xchg rbx, rax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; exit the program gracefully
	mov rax, 60					; or 0x3c in hex
	mov rdi, 0
	syscall


section .data
	sample: db 0xaa,0xbb,0xcc,0xdd,0xee,0xff,0x11,0x22
	sample2: dq 0x1122334455667788
	sample3: times 8 db 0x00
	

	
