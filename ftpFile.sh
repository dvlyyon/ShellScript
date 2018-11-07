#!/bin/bash

vDate=`date +%Y%m%d` 
vHost="172.29.22.244"
vUser=user
vPasswd=password
vFile=YANG.tar.gz
vExecute="du"
vFType=yang
while getopts "w:u:p:h:l:d:f:e:t:r" vOption
do
	case ${vOption} in
		w) vWork=$OPTARG ;;
		u) vUser=$OPTARG ;;
		p) vPasswd=$OPTARG ;;
		h) vHost=$OPTARG ;;
		l) vLoadNum=$OPTARG ;;
        f) vFile=$OPTARG ;;
		d) vDate=$OPTARG ;;
        e) vExecute=$OPTARG ;;
        t) vFType=$OPTARG ;;
        r) vRelease=RELEASE;;
		?) echo "unknown option ${vOption}" ;;
	esac
done

[[ "$vUser" == "user" ]] && { read -t 30 -p "Please input user name:" vUser; }
[[ "$vPasswd" == "password" ]] && { read -s -t 30 -p "Please input password:" vPasswd; }
[[ "$vFType" == "image" ]] && { vFile="GROOVE_G30_${vLoadNum}_${vDate}.*"; }

echo -e "\n\nPlease make sure the following information:"
echo "----------------------------------------------"
echo "work directory:$vWork"
echo "user: ${vUser},  password: ${vPasswd}"
echo "host: ${vHost}"
echo "load Number: ${vLoadNum}"
echo "date: ${vDate} "
echo "file: ${vFile}"
echo "file type: ${vFType}"
echo "execute: ${vExecute}"
echo "-----------------------------------------------"
vConfirm=Y
read -t 30 -p "Are you sure?:[N]" vConfirm
echo $vConfirm
[[ "X$vConfirm" != "XY" ]] && exit 1;

[ "x${vLoadNum}" == "x" ] && { echo "usage ftpFile.sh [-w work_directory] [-u user] [-p password] [-h host] -l load_num [-d date] [-f file_name] [-t \{yang|image\}] [-e what_to_do]"; exit 1; }

function download {
    test -f ${vFile} && { echo "delete ${vFile} ..."; rm ${vFile}; }
    vFullFile="/LoadBuild/DCI${vLoadNum}/${vRelease}/GROOVE_G30_${vLoadNum}_${vDate}/${vFile}"
    echo "try get from $vHost file $vFullFile"
    test -f /usr/bin/expect || { echo "expect must be installed"; exit 1; }
/usr/bin/expect << EOF
spawn scp ${vUser}@${vHost}:${vFullFile} .
expect "password: "
send "${vPasswd}\r\n"
wait 
send_user "\n"
EOF

    if [[  -f ${vFile} ]];
    then
	    echo "download ${vFile} successfully";
    else
	    echo "no ${vFile} found";
	    exit 1;	
    fi
}

function untar {
    echo "==== untar ${vFile}..."
    tar zxvf ${vFile}
}

function yang2dsdl {
    echo "==== produce data dsdl...."
    yang2dsdl -d ../dsdl -t data ne.yang -p ../yang
    echo "==== produce config dsdl...."
    yang2dsdl -d ../dsdl -t config ne.yang -p ../yang
    echo "==== produce get-reply dsdl...."
    yang2dsdl -d ../dsdl -t get-reply ne.yang -p ../yang
    echo "==== produce get-config-reply dsdl...."
    yang2dsdl -d ../dsdl -t get-config-reply ne.yang -p ../yang
    echo "==== produce edit-config dsdl...."
    yang2dsdl -d ../dsdl -t edit-config ne.yang -p ../yang
    echo "==== produce ne notification dsdl...."
    yang2dsdl -d ../dsdl -t notification ne.yang -p ../yang
    echo "==== produce rpc dsdl...."
    yang2dsdl -d ../dsdl -t rpc nbi/coriant-rpc.yang -p ../yang
    echo "==== produce rpc-reply dsdl...."
    yang2dsdl -d ../dsdl -t rpc-reply nbi/coriant-rpc.yang -p ../yang
    echo "==== produce fault notification dsdl...."
    yang2dsdl -d ../dsdl -t notification fault/fault-management.yang -p ../yang
}

function refreshYang {
    [ "x${vWork}" == "x" ] || pushd ${vWork}
    pushd yang
    download
    untar
    yang2dsdl
    popd yang
    [ "x${vWork}" == "x" ] || popd ${vWork}
}

if [[ "${vExecute}" == "y" ]] 
then 
    refreshYang
elif [[ "${vExecute}" == *d* ]]
then
    echo "download file ..."
    download
    if [[ "${vExecute}" == *u* ]]
    then
        echo "untar file..."
        untar
    fi
fi

# vim: syntax=bash
