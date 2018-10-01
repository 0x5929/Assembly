#!/bin/bash

# written to automate retrieving the hex dump from an objdump output
# usage: call this script with the executable as a parameter to retrieve its hex machine code


# NOTE: the command: |cut -f1-6 -d' '|
#	field 1 through 6 using delimiter of space ' '
#	the hexdump by objdump has more than 6 fields if certain nasm opcode/operand needs it
#	so lets increase it to 9 for insurance purposes

objdump -d $1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-9 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g' | paste -d '' -s | sed 's/^/"/' | sed 's/$/"/g' 

