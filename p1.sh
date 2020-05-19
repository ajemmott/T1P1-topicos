#!/bin/bash
#Arturo Jemmott 8-908-2064 arturo.jemmott@utp.ac.pa

HOME=$(pwd)

#1
cd "./src/p1/genes"
ls -aR
cd "$HOME"

#2
cd "./src/p1/genes"
ls -aRL
cd "$HOME"

#3
cd "./src/p1/genes/Ypestis"
cat genes.fasta | egrep -v \> | egrep -o [ACGT] | sort | uniq -c
tail genes.fasta -n +2 | egrep -o [AGCT] | wc -l
cd "$HOME"