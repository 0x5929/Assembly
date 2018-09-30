#!/bin/bash

# could also check for input params, if missing, help message comes out with instruction

echo '[+] Assembling with Nasm...'

nasm -f elf32 -o $1.o $1.nasm


echo '[+] Linking...'

ld -o $1 $1.o


echo '[+] Done!'
