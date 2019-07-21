#!/bin/bash

#Set the environment variable DEBIAN_FRONTEND=noninteractive, This will make apt-get select the default options.
export DEBIAN_FRONTEND=noninteractive

#update the OS and install pip3
sudo apt-get update -y
sudo apt-get install python3-pip -y
pip3 --version
#boto3 required by dynamic inventory script
python3 -m pip install --user boto3

#Install aws cli, ensure an IAM role is attached to your bastion host OR do `aws configure`
sudo pip3 install awscli

#Install Ansible:
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y
ansible --version

#Install python-netaddr, Allow IPv4 forwarding and disable Firewall
sudo apt-get install python-netaddr -y
sudo sysctl -w net.ipv4.ip_forward=1
sudo ufw disable

#Copy .pem key pair -- this is IMP, we need .pem to run kubespray playbook
#cd /home/ubuntu
#vi ssh.pem
#chmod 600 /home/ubuntu/ssh.pem
