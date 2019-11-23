#!/usr/bin/python3

from openpyxl import Workbook
import datetime

wb = Workbook()
ws = wb.active
ws.title = "Memory Statistics"
file=[]
file.append(open('timer.memo','r'))
file.append(open('MF.VmData.memo', 'r'))
file.append(open('MF.percpu.memo', 'r'))
file.append(open('MF.permemo.memo', 'r'))
file.append(open('SMF.VmData.memo', 'r'))
file.append(open('SMF.percpu.memo', 'r'))
file.append(open('SMF.permemo.memo', 'r'))

title = ["Time", "MF VmData", "MF CPU %", "MF Memory %", "SMF VmData", "SMF CPU %", "SMF Memory %"]
for col in range(0, len(title)):
    ws.cell(row=1,column=col+1).value=title[col]

row = 2;
#tValue = file[0].readline()
for tValue in file[0]:
    print(tValue.strip())
    date = datetime.datetime.strptime(tValue.strip(),'%b %d %H:%M:%S %Y')
    ws.cell(row=row,column=1,value=date)
#    ws.cell(row=row,column=1,value=date.strftime('%Y/%m/%d %H:%M'))
    for col in range(1,7):
        value = str(file[col].readline()).strip()
        ws.cell(row=row, column=col+1, value=value)
    row=row+1
#    tValue=file[0].readline()

wb.save("telemetry.xlsx")
for i in range(0,7):
    file[i].close()
