#/bin/sh
echo "[couchbase-main]" > hosts
aws ec2 describe-instances --filter Name=tag:Name,Values=Couchbase --query "Reservations[*].Instances[0].NetworkInterfaces[0].PrivateIpAddress" | tr -d '",[] '|sed '/^$/d'|sed -n 1p >> hosts

echo "[couchbase-nodes]" >> hosts
aws ec2 describe-instances --filter Name=tag:Name,Values=Couchbase --query "Reservations[*].Instances[0].NetworkInterfaces[0].PrivateIpAddress" | tr -d '",[] '|sed '/^$/d'|sed -n 2p >> hosts
aws ec2 describe-instances --filter Name=tag:Name,Values=Couchbase --query "Reservations[*].Instances[0].NetworkInterfaces[0].PrivateIpAddress" | tr -d '",[] '|sed '/^$/d'|sed -n 3p >> hosts

echo "[all:vars]
ansible_ssh_private_key_file=<PRIVATE KEY FILE PATH> 
ansible_ssh_user=ec2-user" >> hosts
