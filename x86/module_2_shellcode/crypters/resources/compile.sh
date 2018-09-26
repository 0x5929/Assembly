#!/bin/bash


# this script is used to compile the input c program 
# with two additional options

# 1. no stack protector --> allows overwrites to the stack memory?
# 2. execstack		--> allows a program EIP points to the stack and with execute privlege


# without the two options above, this program will result in seg fault after control gets passed, 
# if the shellcode contains stack memory manipulaters, and or ret/pops memory off the stack into EIP
# and continue executing program


# please remember to remove .c extension when compiling

gcc -fno-stack-protector -z execstack $1.c -o $1
