#!/bin/bash
flex AF.l
bison -d bison.y
gcc lex.yy.c bison.tab.c -lfl
./a.out "$1"