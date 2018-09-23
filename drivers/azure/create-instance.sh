#!/bin/sh
. /etc/polynimbus/azure/default.sh

if [ "$4" = "" ]; then
	echo "usage: $0 <region> <ssh-key-name> <instance-type> <image-name>"
	exit 1
fi

region=$1
key=$2
type=$3
image=$4

pubkey=/etc/polynimbus/ssh/id_azure_$key.pub
random=`date +%s |md5sum |head -c 4`
alias=$key-$random

if [ ! -f $pubkey ]; then
	echo "error: ssh public key for \"$key\" not found"
	exit 0
fi

group=`/opt/polynimbus/drivers/azure/get-group-name.sh $region`
/opt/polynimbus/drivers/azure/create-group.sh $region $group >/dev/null

az vm create \
	--name $alias \
	--size $type \
	--resource-group $group \
	--admin-username ubuntu \
	--public-ip-address-dns-name $alias \
	--location $region \
	--image $image \
	--ssh-key-value $pubkey \
	--output json \
	|/opt/polynimbus/drivers/azure/internal/parse-create.php $type $image

dt=`date +%Y-%m-%d`
echo "$alias $dt" >>/var/cache/polynimbus/azure/created.list

# example output:
# test1-7761.eastus.cloudapp.azure.com running test1 eastus Standard_A2 test1-7761 Canonical:UbuntuServer:18.04-LTS:latest 2018-06-17 test-key=test-value;test-key2=test-value2
