#!/bin/zsh
IFS=$'\n'

for f in $(ls *.MP3) 
do  
    fn=$(echo ${f%%.*} | sed -E 's/-[0-9]+//g')  
    id3tool -t "$fn" -a "New Concept English 1" -n "新概念英语第一册" $f 
    id3tool $f 
done
