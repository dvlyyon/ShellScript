#!/bin/bash
[[ -f $1 ]] && { for i in `cat $1`; do printf \\$(printf "%o" $i); done; } && exit 0
echo "Usage: $(basename $0) file_name"
