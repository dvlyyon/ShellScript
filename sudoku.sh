#!/bin/bash

echo "sudoku[$1,$2]=$3 $#"

declare -a sudoku
for (( i=0; i<81; i++ ))
do
	sudoku[i]=0
	sudoku1[i]=0
done

function checkLineCol {
	[[ $1 -ge 1 && $1 -le 9 ]]
}

function checkNum {
	[[ $1 -ge 0 && $1 -le 9 ]]
}

function readLine() {
	while [[ 1 ]]
	do
		read -p "please input the predefined number: " line col num
		[[ "$line" == "" ]] && continue
		[[ "$line" == "end"  ]] && break
		{ checkLineCol $line && checkLineCol $col && checkNum $num; } || { echo "line colume number must be in [1, 9]" && continue; }
		sudoku[((($line-1)*9+$col-1))]=$num
	done
}

function canLine () {
	local col
	for (( col=1; col <=9; col++ ))
	do
		if [[ $col == $2 ]] ; then continue; fi
		((idx=( $1-1 )*9 + ( $col-1 )))
		if [[ ${sudoku[$idx]} == $3 ]] 
		then 
			echo "line:$1 colume:$col num:${sudoku[$idx]} result:false"
			return 1
		fi
	done
	echo "line:$1 colume:$2 num:$3 result:true"
	return 0
}

function canColume () {
	local line
	for (( line=1; line<=9; line++ ))
	do
		if [[ $line == $1 ]]; then continue; fi
		if [[ ${sudoku[ ((($line-1)*9 + ($2-1)))]} == $3 ]] 
		then 
			((idx=( $line-1 )*9 + ( $2-1 )))
			echo "line:$line colume:$2 num:${sudoku[$idx]} result:false"
			return 1 
		fi
	done
	echo "line:$1 colume:$2 num:$3 result:true"
	return 0
}

function canSqure() {
	local line
	local col
	local num
	for (( line=1; line <= 9; line++ ))
	do
		if (( (line-1)/3 != ($1-1)/3 )); then continue; fi
		for (( col=1; col <=9; col++ ))
		do
			if (( (col-1)/3 != ($2-1)/3 )); then continue; fi
			echo "line:$line col:$col"
			if (( ${sudoku[ ((( $line-1 )*9 + ( $col-1 ))) ]} == $3 )) 
			then
				(( idx=( $line-1 )*9 + ( $col-1 )))
				echo "line:$line colume:$col num:${sudoku[$idx]}, result:false"
				return 1 
			fi
		done
	done
	echo "line:$1 colume:$2 num:$3 result:true"
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
	echo $1
	if (( sudoku[$1] != 0 ))  
	then 
		if (( $1 == 80 ))
		then
			return 0
		else 
			autocomplete `(( $1+1 ))` 
		fi
	fi
	local i;
	local j;
	local n;
	local t;
	(( i=$1/9+1 )) && (( j=$1%9+1 ))
	for (( n=1; n<=9; n++ ))
	do 
		echo "line:$i colume:$j num:$n"
		if [[ $(canLine $i $j $n) && $(canColume $i $j $n) && $(canSqure $i $j $n) ]]
		then
			sudoku[$1]=$n
			if [[ $(autocomplete $( (($1+1)) ) ) ]]
			then
				break;
			else
				continue;
			fi
		else
			continue;
		fi
	done
	if (( n==10 )) 
	then
		sudoku[$1]=0
		return 1
	else
		return 0
	fi
}

select name in input auto undo show quit
do
	[[ "$name" == "input" ]] &&  readLine 
	[[ "$name" == "undo" ]] &&  echo "TBD" 
	[[ "$name" == "auto" ]] &&  canLine 1 1 2 && canColume 1 1 2 && canSqure 1 1 2
	[[ "$name" == "show" ]] && printSudoku
	[[ "$name" == "quit" ]] && exit 0
done


