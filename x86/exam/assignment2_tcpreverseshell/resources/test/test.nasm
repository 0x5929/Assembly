global _start
section .text
_start:
	push 0x0
	push 0x1
	
	push 0x0
	
	push word 2
	push word 4

	pop edi


	; exit
	mov al, 0x1
	mov bl, 0x0
	int 0x80
