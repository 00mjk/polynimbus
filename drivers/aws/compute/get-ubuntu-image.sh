#!/bin/sh

if [ "$1" = "" ]; then
	echo "usage: $0 <cloud-account>"
	exit 1
elif ! grep -q "\[$1\]" /root/.aws/credentials; then
	echo "error: cloud account \"$1\" not configured"
	exit 1
fi

account=$1
version="18.04"

region=`/opt/polynimbus/drivers/aws/compute/get-configured-region.sh $account`

/opt/polynimbus/drivers/aws/compute/get-ami-id.sh $region $version
