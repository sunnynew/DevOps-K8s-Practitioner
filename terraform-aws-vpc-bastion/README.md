Build infra for kubernetes cluster
----------------------------------
Prerequisites: terraform

Steps to install terraform on linux

1). mkdir terraform

2). cd terraform

3). wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip

4). unzip terraform_0.11.13_linux_amd64.zip 

5). mv terraform /usr/local/bin/

Steps:
------
1). Change values in variables.tf file : access_key, secret_key, key_name [key pair name], change # of instances if youwant.

2). terraform init

3). terraform apply
