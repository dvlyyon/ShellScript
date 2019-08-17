#!/bin/bash

## show CPU and GPU temperature
cpu=$(cat /sys/class/thermal/thermal_zone0/temp)
echo "$(date) @ $(hostname)"
echo "-------------------------------"
echo "GPU => $(/opt/vc/bin/vcgencmd measure_temp)"
echo "CPU => $((cpu/1000))'C"

## show kernel configuration
echo "configuration with int type"
vcgencmd get_config int
echo "configuration with string type"
vcgencmd get_config str

## show clock frequency
for src in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi 
do
	echo -e "$src:\t$(vcgencmd measure_clock $src)"
done

for id in core sdram_c sdram_i sdram_p
do
	echo -e "$id:\t$(vcgencmd measure_volts $id)"
done

vcgencmd get_mem arm && vcgencmd get_mem gpu

vcgencmd display_power

vcgencmd get_throttled
