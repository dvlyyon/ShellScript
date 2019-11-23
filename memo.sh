#!/bin/bash

cat $1 | grep -e "- MF Detailed" -A 13 > MF.memo
cat $1 | grep -e "- SMF Detailed" -A 13 > SMF.memo
cat $1 | grep -e "- Memory by Top" -A 3 > top.memo 
cat MF.memo | grep -e "- MF Detailed" | cut -d ' ' -f 5,6,7,9 > timer.memo
cat MF.memo | grep -e "VmData" | cut -d ' ' -f 2 > MF.VmData.memo
cat SMF.memo | grep -e "VmData" | cut -d ' ' -f 2 > SMF.VmData.memo
cat top.memo | grep -e " MF.bin" | cut -d ' ' -f 11 > MF.percpu.memo
cat top.memo | grep -e " MF.bin" | cut -d ' ' -f 12 > MF.permemo.memo
cat top.memo | grep -e " SMF.bin" | cut -d ' ' -f 11 > SMF.percpu.memo
cat top.memo | grep -e " SMF.bin" | cut -d ' ' -f 12 > SMF.permemo.memo
2excel.py
