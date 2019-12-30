#!/bin/sh

compartment=`/opt/polynimbus/drivers/oracle/compute/get-compartment-id.sh`

file=/var/cache/polynimbus/oracle/instance-types.cache

if [ ! -s $file ] || [ `stat -c %Y $file` -le `date -d '-8 hours' +%s` ]; then
	oci compute shape list --compartment-id $compartment --all >$file
fi

grep '"shape":' $file |awk '{ print $2 }' |sed s/\"//g |sort |uniq
