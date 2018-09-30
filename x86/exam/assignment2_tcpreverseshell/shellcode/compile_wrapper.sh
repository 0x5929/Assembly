#!/bin/bash


# compile with no stack protector, and exec stack


gcc -fno-stack-protector -z execstack $1
