; File: strings.nasm
; Aurthor: Kevin Ren, originally professor Viviek of SLAE64
; Purpose: to demostrate string comparison and scan

global _start


section .text

scan_found:
	mov rsi, scanfound				; this should never output
	mov rdx, scanfoundlen
	jmp print_scan_result				; jmp to print scan results

comp_found:
	mov rsi, compfound				; this should output
	mov rdx, compfoundlen
	jmp print_comp_result

_start:

scan_string: 
; LECTURE
	; scasb/w/d/q
	; compare memory to register
	
	cld						; clearing the direction flag
	mov rax, 0x1234567890abcdef
	mov rdi, var1
	scasq

	mov rdi, var2
	scasq

; HOMEWORK
	; this is where homework starts
	mov rcx, 8					; var2 is 8 bytes, counter for repne
	mov rax, 0xff					; loading the comparable byte
	
	cld
	repne scasb					; repeat scansb if not found (ZF not set)

	jz scan_found					; once found (ZF set/repne scasb stops execution) 

scan_no_found:
	mov rsi, no_found				; msg
	mov rdx, no_foundlen
	
print_scan_result: 
	mov rax, 0x1					; write syscall
	mov rdi, 0x1					; stdin
	syscall						; print scan result


; LECTURE NOTES
	; cmpsb/w/d/q
	; compare memory to memory
	
	cld
	mov rsi, var1
	mov rdi, var3
	cmpsq

; HOMEWORK
	mov rcx, compare_stringlen
	mov rsi, compare_string
	mov rdi, comp_byte
	
	cld
	repz cmpsb
	
	jz comp_found
	
	mov rsi, compnofound
	mov rdx, compnofoundlen

print_comp_result:
	mov rax, 0x1
	mov rdi, 0x1
	syscall

; MOVE STRING, from mem to mem
	cld
	mov rcx, compare_stringlen
	lea rsi, [compare_string]
	lea rdi, [destination]
	
	rep movsb	
	
	mov rax, 0x1				; print out new string
	mov rdi, 0x1
	mov rsi, destination
	mov rdx, compare_stringlen 
	syscall

; STORE STRING, from reg to mem
	cld
	mov rax, "11111111"
	mov rcx, 0x8
	lea edi, [dest]
	rep stosb
	
	mov rax, 1
	mov rdi, 1
	mov rsi, dest
	mov rdx, 8
	syscall	

; LOAD STRING, from mem to reg, need to reload 
	xor rax, rax
	lea rsi, [dest]	
	lodsq
	push qword rax	

	mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 8
	syscall

exit:
	
	; exit syscall
	mov rax, 0x3c
	mov rdi, 0x0
	syscall

section .data
	var1: dq 0x1234567890abcdef
	var2: dq 0xfedcba1234567890
	var3: dq 0x1234567890abcdef

	; variables for hw
	no_found : db "Did  not find byte 0xag in var2", 0xa
	no_foundlen equ $ - no_found 
	
	scanfound: db "this should never output", 0xa
	scanfoundlen equ $ - scanfound
	
	compare_string: db "hello world", 0xa
	compare_stringlen equ $ - compare_string
	comp_byte: db "hello world",0xa

	compfound: db "found w inside hello world string", 0xa
	compfoundlen equ $ - compfound
	
	compnofound: db "this should never output from compnofound",0xa
	compnofoundlen equ $ - compnofound

section .bss
	storage: resb 100
	destination: resb 12
	dest: resb 8
