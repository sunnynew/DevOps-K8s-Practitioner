#!/bin/bash

#Set the following AWS credentials and info as environment variables in your terminal:
export AWS_ACCESS_KEY_ID="xxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxx"
export REGION="us-east-2"

#Clone kubespray git repo
git clone https://github.com/kubernetes-incubator/kubespray.git

#Install python dependencies
cd kubespray/
pip3 install -r requirements.txt

#start Kubespray configuration
cp -rfp inventory/sample  inventory/mycluster

#We will use dynamic inventory script for AWS
#We have already added tags to the instances with a key "kubespray-role" and a value of kube-master, etcd, or kube-node. [Done in terraform]
cp contrib/aws_inventory/kubespray-aws-inventory.py inventory/

#Use python3
sed -i 's/python/python3/' inventory/kubespray-aws-inventory.py

#Made kubespray generate a kubeconfig file on the computer used to run Kubespray
echo 'kubeconfig_localhost: true' >> inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml
echo 'cloud_provider: aws' >> inventory/mycluster/group_vars/all/all.yml

#Now lets finally run ansible playbook and setup k8s cluster:
#Save key-pair.pem which you attached to ec2 instances, allow ansible to ssh
ansible-playbook -i inventory/kubespray-aws-inventory.py --user ubuntu -b -v cluster.yml -e cloud_provider=aws --private-key=/home/ubuntu/ssh.pem

#Configure kubectl
mkdir -p ~/.kube
#Pick master node to copy admin.conf file
master=$(aws ec2 describe-instances --filters "Name=tag:kubespray-role,Values=*" --output text --query 'Reservations[*].Instances[*].[PrivateIpAddress,Tags[?Key==`kubespray-role`].Value]' --region us-east-2|sed 'N;s/\n/ /'|grep kube-master|grep -iv None|head -1|awk '{print $1}')
echo $master
ssh -i /home/ubuntu/ssh.pem -o StrictHostKeyChecking=no ubuntu@${master}  'sudo cat /etc/kubernetes/admin.conf' > ~/.kube/config
export KUBECONFIG=~/.kube/config

#Enable PV dynamic provisioning/Default Storage Class
kubectl create -f storageclass.yaml
