#!/bin/bash


# this script is made to compile our skeleton c file to test shellcodes

# using options to turn off stack protector, and making the stack executable, if needed
# ie BoF attacks, we need to execute the payload from stack, that option is optimal

gcc -fno-stack-protector -z execstack shellcode.c -o test_shellcode
