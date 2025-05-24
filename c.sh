#!/bin/bash
# ----------------------------------------------------------
# Script Name:     c.sh
# Description:     simplifies the process of compiling a program written in C.
# Author:          0x64azana
# Created:         xxxx-xx-xx
# Version:         1.0
# Usage:           
# > mv ./c.sh /usr/bin/c
# > c program.c
# ----------------------------------------------------------
gcc $1

echo ''
firejail ./a.out
echo ''
rm ./a.out

