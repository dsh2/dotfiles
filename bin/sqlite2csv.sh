#!/bin/bash
me="$(basename ${BASH_SOURCE[0]})"
set -e
die() { echo "ERROR: $*"; exit 1; }

[[ $# -ge 1 && $# -le 2 ]] || die "usage: $me sqlite_database [--overwrite]"
db=$1
[ -r $db ] || die "Failed to read $db" 
[[ $2 == "--overwrite" ]] && overwrite=1
out_dir=$db.dir
[[ -d $out_dir && $overwrite ]] || mkdir $out_dir

tables=($(sqlite3 "$db" ".tables"))

for table in "${tables[@]}"; do
	out=$out_dir/$table.csv
	sqlite3 "$db" <<- EXIT_HERE
		.mode csv
		.headers on
		.output $out
		SELECT * FROM $table;
		.exit
	EXIT_HERE
	echo "$out generated"
done
