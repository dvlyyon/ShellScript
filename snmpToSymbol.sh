#!/bin/bash

export MIBDIRS=$MIBDIRS:~/Workspace/mib:/var/lib/mibs/ietf:/var/lib/mibs/iana
echo $MIBDIRS
/usr/bin/snmptranslate -m ALL -Ts $*
