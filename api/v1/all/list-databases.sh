#!/bin/sh

for vendor in `ls /opt/polynimbus/drivers`; do
	ACCS=`/opt/polynimbus/api/v1/account/list.sh $vendor`
	for account in $ACCS; do

		if [ "$vendor" != "aws" ]; then
			/opt/polynimbus/api/v1/database/list.sh $vendor $account |sed -e "s/^/$vendor $account /"
		else
			regions=`/opt/polynimbus/api/v1/region/list-available.sh $vendor $account`
			for region in $regions; do
				/opt/polynimbus/api/v1/database/list.sh $vendor $account $region |sed -e "s/^/$vendor $account /"
			done
		fi
	done
done
