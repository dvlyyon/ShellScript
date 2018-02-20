#!/bin/bash

device="none"
mountpoint="none"
keyfile=
passwd="none"
operation="none"
name="none"

while getopts "ocd:n:m:kph" op 
do
	case $op in
		o)
			[[ "$operation" != "none" ]] && echo "You can only do open with -o or close with -c, and NOT both"  && exit 1
			operation=open;;
		c)
			[[ "$operation" != "none" ]] && echo "You can only do open with -o or close with -c, and NOT both"  && exit 1
			operation=close;;
		d)
			device=$OPTARG;;
		m)
			mountpoint=$OPTARG;;
		n)
			name=$OPTARG;;
		k)
			read -s -t 30 -p "Please input the key file: " keyfile
			keyfile="-d $keyfile";;
		p)
			read -s -t 30 -p "Please input the password: " passwd;;
		h)
			hideopt="--tcrypt-hidden";;
		?)
			echo "Don't identify option $op"
			exit 1 ;;
	esac
done

case $operation in
	open)
		[[ "$name" == "none" ]] && name=$(basename $device)
		[[ "$device" == "none" || "$name" == "none" || "$mountpoint" == "none" ]] && echo "missing some argument for open " && exit 1
		mountpoint=$mountpoint/${name}
		sudo mkdir -p ${mountpoint}
		sudo cryptsetup open $device $name --type tcrypt --veracrypt $hideopt $keyfile && sudo mount /dev/mapper/$name $mountpoint
		echo "Success: open file to $mountpoint";;
	close)
		[[ "$name" == "none" || "$mountpoint" == "none" ]] && echo "option n and m must be set for close" && exit 1
		sudo umount $mountpoint/${name} && sudo rm -rf $mountpoint/${name}
		sudo cryptsetup close $name
		echo "Success: closed";;
	none)
		echo "please select action";;
esac


