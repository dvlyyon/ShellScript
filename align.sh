#!/bin/bash

cat $* |
while read number1 number2
do
    printf "%12d %12d\n" $number1 $number2
done
