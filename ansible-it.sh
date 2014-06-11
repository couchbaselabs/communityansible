#!/bin/sh

# generate some pseudo-random chars to prefix the CloudFormation stack name
PRANDOM=$(LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | fold -w ${1:-8} | head -n 1)

echo "Creating CloudFormation stack"
aws cloudformation create-stack --stack-name Couchbase-$PRANDOM --template-body file://couchbase_3node_3az.template --parameters file://mycfnparams.json

echo "Sleeping for 5 minutes while stack creation completes..."
sleep 300

echo "Output filtered list of private IPs of new EC2 instances to stdout... piping to 'hosts'"
sh instance_list.sh

echo "run ansible playbook against new hosts file, installing and running multi-AZ Couchbase Server cluster"
ansible-playbook -i ./hosts ./playbook.yml -vv
