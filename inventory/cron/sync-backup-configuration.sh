#!/bin/sh

key=$1
target=root@$2

rsync -e "ssh -i $key" -a --delete /var/cache/polynimbus/aws/s3cmd $target:/var/cache/polynimbus/aws
rsync -e "ssh -i $key" -a --delete /var/cache/polynimbus/azure/storage-accounts $target:/var/cache/polynimbus/azure
scp -p -i $key /var/cache/polynimbus/inventory/object-storage.list $target:/var/cache/polynimbus/inventory
scp -p -i $key /var/cache/polynimbus/aws/s3-backup.blacklist $target:/var/cache/polynimbus/aws
