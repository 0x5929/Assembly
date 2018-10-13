#!/bin/bash

# written to automate retrieving the hex dump from an objdump output
# usage: call this script with the executable as a parameter to retrieve its hex machine code

for i in $(objdump -d $1 | grep "^ " |cut -f2); do echo -n '\x'$i; done; echo
