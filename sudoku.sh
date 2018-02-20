#!/bin/bash

echo "sudoku[$1,$2]=$3 $#"

declare -a sudoku
for (( i=0; i<81; i++ ))
do
	sudoku[i]=0
	sudoku1[i]=0
done

function checkNum {
	[[ $1 -ge 1 && $1 -le 9 ]]
}

function readLine() {
	while [[ 1 ]]
	do
		read -p "please input the predefined number: " line col num
		[[ "$line" == "" ]] && continue
		[[ "$line" == "end"  ]] && break
		{ checkNum $line && checkNum $col && checkNum $num; } || { echo "line colume number must be in [1, 9]" && continue; }
		sudoku[((($line-1)*9+$col-1))]=$num
	done
}

function canLine () {
	local col
	for (( col=1; col <=9; col++ ))
	do
		if (( col == $2 )) ; then continue; fi
		if (( sudoku[ (( ($1-1)*9 +($2-1) )) ] == $3 )); then return 1; fi
	done
	return 0
}

function canColume () {
	local line
	for (( line=1; line<=9; line++ ))
	do
		if (( line == $1 )); then continue; fi
		if (( sudoku[ (( ($1-1)*9 + ($2-1) )) ] == $3 )); then return 1; fi
	done
	return 0
}

function canSqure() {
	local line
	local col
	for (( line=1; line <= 9; line++ ))
	do
		if (( (line-1)/3 != ($1-1)/3 )); then continue; fi
		for (( col=1; col <=9; col++ ))
		do
			if (( (col-1)/3 != ($2-1)/3 )); then continue; fi
			if (( sudoku[ (( ($1-1)*9 + ($2-1) )) ] == $3 )); then return 1; fi
		done
	done
	return 0	
}

function printSudoku() {
	echo "    1  2  3   4  5  6   7  8  9 "
	echo
	for (( line=0; line<9; line++))
	do
		(( lno=$line+1 ))
		printf "%d   "  $lno 
		for (( col=0; col<9; col++))
		do
			echo -n "${sudoku[(($line*9+$col))]}  "
			if (( (col+1)%3 == 0 )) ; then echo -n " "; fi
		done
		echo 
		if (( lno%3 ==  0 )) ; then echo ; fi
	done
}

function autocomplete () {
	local i;
	local j;
	local n;
	for (( i=0; i<9; i++ ))
	do 
		for (( j=0; j<9; j++ ))
		do
			if (( sudoku[(($line*9+$col))] != 0 )) continue;
			for (( n=1; n<=9; n++ ))
			do


select name in input autocomplete undo quit
do
	[[ "$name" == "input" ]] &&  readLine 
	[[ "$name" == "undo" ]] &&  echo "TBD" 
	[[ "$name" == "autocomplete" ]] && echo "TBD" 
	[[ "$name" == "quit" ]] && exit 0
	printSudoku
done


