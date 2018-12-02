#!/bin/sh

/opt/polynimbus/drivers/aws/internal/download-ami-table.sh \
	|/opt/polynimbus/common/save.sh /var/cache/polynimbus/aws ubuntu-ec2-images.json

/opt/polynimbus/drivers/aws/internal/download-instance-types.sh \
	|/opt/polynimbus/common/save.sh /var/cache/polynimbus/aws ec2-instance-types.html

accounts=`/opt/polynimbus/drivers/aws/list-accounts.sh |grep -vxFf /var/cache/polynimbus/aws/list-users.blacklist`
for account in $accounts; do
	/opt/polynimbus/drivers/aws/list-users.php $account \
		|/opt/polynimbus/common/save.sh /var/cache/polynimbus/inventory users-aws-$account.list
done

accounts=`/opt/polynimbus/drivers/aws/list-accounts.sh`
for account in $accounts; do
	/opt/polynimbus/drivers/aws/list-security-groups.php $account --raw \
		|/opt/polynimbus/common/save.sh /var/cache/polynimbus/inventory acl-aws-$account.json
done

projects=`/opt/polynimbus/drivers/google/list-projects.sh default |grep -vxFf /var/cache/polynimbus/google/get-iam-policy.blacklist`
for project in $projects; do
	/opt/polynimbus/drivers/google/list-users.sh default $project \
		|/opt/polynimbus/common/save.sh /var/cache/polynimbus/inventory users-google-$project.list
done
