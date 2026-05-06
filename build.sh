#!/bin/bash

gcc -c main.c -o main.o
gcc -x assembler -c upn.asm -o upn.o
gcc main.o upn.o -o upn
