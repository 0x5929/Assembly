; hello_world.asm
; Author: Kevin Ren


; this is a comment for assembly language


; executable we create is in ELF format, common for linux systems

; defining the global identifier for linker, _start is nasm assembler convention
global _start


; text section, same as code section, contains executable instructions 
section .text

; identifying to linker where the entire program will start executing aka not in data, but this exact point
_start: 

	; print to screen using system call write 
	mov eax, 0x4		; system call number 4
	mov ebx, 0x1  		; file descriptor 1 for standard output
	mov ecx, message
	mov edx, len_msg

; 	after all registers are in place, hand the control over to kernel by using int 0x80
	int 0x80

;---------------------------------------------------------------------------------------------------------------
	
	; exit gracefully using system call exit
	mov eax, 0x1	; system call number 1
	mov ebx, 0x0	; passing in 0 for success exit status

; after all registers are in place, lets invoke system call by using the interrupt handlers table --> system call handler --> systemcall routines
; by using int 0x80
	int 0x80



; data section, for constants, initialized data
section .data
	
; 	below presents two ways to define the string, both with new line feeds

;	message: db `Hello, World!\n`
	message: db "Hello, World!", 0xa

; 	the length of the message string is calculated with $ --> current memory address minus the beginning of the message string address
	len_msg equ $ - message

