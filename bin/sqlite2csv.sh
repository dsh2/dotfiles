#!/bin/bash

#########################################################################
# 
# Author: Darren Tu  github.com/darrentu
# Please read README before running the program
# 
#########################################################################


if [ "$1" = "" ]
then
	echo "You must enter the name of the database. Please check the README."
	exit 1
fi

t=($(sqlite3 "$1" ".tables"))

for i in "${t[@]}"
do
	sqlite3 "$1" <<- EXIT_HERE
	.mode csv
	.headers on
	.output $i.csv
	SELECT * FROM $i;
	.exit
	EXIT_HERE
  echo "$i.csv generated"
done
