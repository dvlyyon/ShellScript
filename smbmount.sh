#!/bin/bash

while getopts "h:u:p:s:m:" vOption
do
	case ${vOption} in
		h) vHost=$OPTARG ;;
		u) vUser=$OPTARG ;;
		p) vPass=$OPTARG ;;
		s) vService=$OPTARG ;;
		m) vMount=$OPTARG ;;
		?) echo "unknow option $vOption" ;;
	esac
done

if [[ "x${vPass}" == "x" ]]
then
	read -s -t 30 -p "Please input the password: " vPass
fi

[ "x${vService}" == "x" ] &&  vService=${vUser} 

#echo h:${vHost} u:${vUser} p:${vPass} s:${vService} m:${vMount}

( [ "x${vHost}" == "x" ] || [ "x${vUser}" == "x" ] || [ "x${vPass}" == "x" ] || [ "x${vService}" == "x" ] || [ "x${vMount}" == "x" ] ) && { echo "Usage smbmount.sh -h host -u user_name -p password -s service -m mountpoint"; exit 1; }

sudo mount -t cifs -o user=${vUser},password=${vPass} //${vHost}/${vService} ${vMount} 



