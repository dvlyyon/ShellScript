#!/bin/bash

path=""
module="ne.yang"
output="tree.html"

while getopts "m:o:" vOption
do
    case ${vOption} in
        m) module=$OPTARG ;;
        o) output=$OPTARG ;;
        ?) echo "unknown opton ${vOption}" ;;
    esac
done

for p in `find . -type d`; do
    path=$p:$path
done

#pyang ne.yang -p $path -f tree -o tree.txt
pyang $module -p $path -f jstree -o $output

