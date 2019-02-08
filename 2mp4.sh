#!/bin/bash

IFS=$'\n'

function getCodec1()
{
    mpv --no-audio --no-video $1 > output.txt; 
    while read line 
    do 
        [[ $line =~ Video[[:space:]].*vid\=1.*[[:space:]]+\((.*)\)$ ]] \
            &&  vcodec=${BASH_REMATCH[1]} ; 
        [[ $line =~ Audio[[:space:]].*aid\=1.*[[:space:]]+\((.*)\)$ ]] \
            &&  acodec=${BASH_REMATCH[1]} ; 
    done < output.txt 
}

function getCodec2()
{    
    for line in `mpv --no-audio --no-video $1`
    do
        echo $line
        [[ $line =~ Video[[:space:]].*vid\=1.*[[:space:]]+\((.*)\)$ ]] \
            &&  vcodec=${BASH_REMATCH[1]} ; 
        [[ $line =~ Audio[[:space:]].*aid\=1.*[[:space:]]+\((.*)\)$ ]] \
            &&  acodec=${BASH_REMATCH[1]} ; 
    done 
 
}

for file in $(ls $1)
do
    echo "Processing $file..."
    fileExp=
    vcodec=
    acodec=
    fileName=${file%.*}
    fileExp=${file##*.}
    newFName=${fileName}.mp4
    getCodec1 $1/$file
    echo "file $file:  vcodec:$vcodec, acodec:$acodec"
    if [[ "$fileExp" == "mp4" && "$vcodec" == "h264" && \
        ( "$acodec" == "aac" || "$acodec" == "mp3") ]]
    then
        echo "move $1/$file to $2/${newFName}"
        mv $1/$file $2/$newFName
    else
        voption=copy
        aoption=copy
        [[ "$vcodec" != "h264" ]] && voption=libx264
        [[ "$acodec" != "aac" && "$acodec" != "mp3" ]] && aoption=aac
        echo convert $file to ${fileName}.mp4
        ffmpeg -i $1/$file -vcodec ${voption} -acodec ${aoption} -f mp4 $2/$newFName
    fi
    echo "------------------------------------------------"
done


