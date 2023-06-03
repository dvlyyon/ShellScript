#!/bin/zsh
IFS=$'\n'

for f in $(ls *.MP3) 
do  
    fn=$(echo ${f%%.*} | sed -E 's/-[0-9]+//g')  
    nm="$(basename $(pwd) | sed 's/MP3.*//g')"
    #id3tool only support id3 v1 version
    #id3tool -t "$fn" -a "$nm" -n "$nm" $f 
    # id3v2 have not a easy way to support unicode
    #id3v2 -2 -t "$fn" -A "$nm" -c "$(basename $(pwd))" $f
    # ffmpeg is a good tool and it need a temp file for output file
    ffmpeg -i $f -metadata title="$fn" -metadata album="$nm" -metadata comment="$(basename $(pwd))" -metadata lyrics-eng="$(cat ${f%.*}.lrc)" -c:a copy $fn.new.mp3
    mv $fn.new.mp3 $f
    # eyeD3 maybe a favourite tool to edit metadata for mpeg file, it is a python script
    #eyeD3 --add-lyrics ${f%.*}.lrc $f
    mpg123-id3dump $f 
done
