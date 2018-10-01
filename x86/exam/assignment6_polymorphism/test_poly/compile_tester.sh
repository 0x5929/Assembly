#!/bin/bash


# compile tester with -fno-stack-protector and -z execstack options


gcc -fno-stack-protector -z execstack $1
