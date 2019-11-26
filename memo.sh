#!/bin/bash

heapconvert.py $1
cat $1.cvt | grep -e "- MF Detailed" -A 18 > MF.memo
cat $1.cvt | grep -e "- SMF Detailed" -A 15 > SMF.memo
cat $1.cvt | grep -e "- Memory by Top" -A 3 > top.memo 

cat MF.memo | grep -e "- MF Detailed" | cut -d ' ' -f 5,6,7,9 > timer.memo
cat MF.memo | grep -e "VmData" | cut -d ' ' -f 2 > MF.VmData.memo
cat MF.memo | grep -e "VmRSS" | cut -d ' ' -f 2 > MF.VmRss.memo
cat MF.memo | grep -e "Threads:" | cut -d ' ' -f 2 > MF.Thread.memo
cat MF.memo | grep -e "heap:" | cut -d ' ' -f 2 > MF.heap.memo
cat SMF.memo | grep -e "VmData" | cut -d ' ' -f 2 > SMF.VmData.memo
cat top.memo | grep -e " MF.bin" | cut -d ' ' -f 11 > MF.percpu.memo
cat top.memo | grep -e " MF.bin" | cut -d ' ' -f 12 > MF.permemo.memo
cat top.memo | grep -e " SMF.bin" | cut -d ' ' -f 11 > SMF.percpu.memo
cat top.memo | grep -e " SMF.bin" | cut -d ' ' -f 12 > SMF.permemo.memo
2excel.py $1
