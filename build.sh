#!/bin/bash

gcc -c main.c -o main.o
gcc -c upn.S -o upn.o
gcc main.o upn.o -o upn
