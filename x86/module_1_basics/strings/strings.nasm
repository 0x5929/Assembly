; File: strings.nasm
; Author: Kevin Ren, originally Professor Viviek of SLAE
; Purpose: to demostrate string operations such as copying and comparison with GDB



global _start

section .text

SameScan:						; if scan has the item in al
	mov eax, 0x4					; call write sys call to print found
	mov ebx, 0x1
	mov ecx, scanFound
	mov edx, scanFoundLen
	int 0x80
	jmp Loads					; jumping back to Loads label


_start:							; program entry point

ScanString:						; using scasb to scan and look for element in string
	mov ecx, sourceLen				; the length of the string we are scanning is the counter, for instruction like rep
	mov al, "e"					; the element we are looking for is loaded into al
	lea edi, [source]				; the string address we are scanning is loaded into edi destination index register
	
	cld						; clearing direction flag, so we scan from low to high
	repne scasb 					; repeat if not found for counter amount of times
	
	je SameScan	 				; once found equal flag will set and this will jump to printing label
	mov eax, 0x4					; if not found, we will print not found with sys call write below
	mov ebx, 0x1
	mov ecx, scanNotFound
	mov edx, scanNotFoundLen
	int 0x80					; sys call write

Loads:							; using lodsb to load byte into al register
	lea esi, [source]				; first we need to load the source string into source index register:  esi
	lodsb						; lodsb instruction, will load H into al

	mov [storage], al				; moving value of al, H, into a predefined uninitilized variable name storage
	mov eax, 0x4					; then we will print out storage
	mov ebx, 0x1
	mov ecx, storage 
	mov edx, 1					; knowing its only one byte, hard coded
	int 0x80					; printing H onto stdo

Copy:					; using movsb instruction to copy from esi to edi
	mov ecx, sourceLen		; counter used to copy bytes of string
	lea esi, [source]		; address of source to be copied from loaded
	lea edi, [destination]		; destination to be copied to 

	cld				; clearing direction flag, so copying will only go one way
	rep movsb			; this will keep on repeating movb until ecx counter reaches 0


	mov eax, 0x4			; write sys call
	mov ebx, 0x1			; stdout
	mov ecx, destination		; print out destination after copy movb operation
	mov edx, sourceLen
	int 0x80			; invocation

Compare:				; using cmpsb to compare byte by byte from esi to edi
	mov ecx, sourceLen		; counter used in comparing bytes of two strings
	lea esi, [source]		; source used to compare from
	lea edi, [comparison]		; destination used to compare to
	
	cld 				; clearing direction flag, so comparson direction will only go one way, and resets that way every repeat
	repe cmpsb			; only repeat cmpsb if zero flag is set


	jz SetEqual			; if all bytes of two strings are equal, then jump to set equal label
	mov ecx, noMatch		; if not we will just print no match message
	mov edx, noMatchLen	
	jmp Print			; jump to print label with registers set
	
SetEqual: 
	mov ecx, match			; print out match message
	mov edx, matchLen

Print:
	mov eax, 0x4
	mov ebx, 0x1
	int 0x80			; invoking write sys_call


Exit: 					; gracefully exits program
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80			; bye


section .data
	
	source: db "Hello World!", 0xa
	sourceLen equ $ - source

	comparison: db "Hello"

	match: db "Strings are equal", 0xa
	matchLen equ $ - match

	noMatch : db "Strings are not equal", 0xa
	noMatchLen equ $ - noMatch

	scanFound : db "found item in scanned edi", 0xa
	scanFoundLen equ $ - scanFound

	scanNotFound : db "did not find item in scanned edi", 0xa 
	scanNotFoundLen equ $ - scanNotFound

	
section .bss
	
	destination: resb 100		; reserve 100 bytes for uninitialized data, used for movsb result
	storage: resb 100		; used for lodsb result
