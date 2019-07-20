# DevOps-K8s-Practitioner

Cloud Provider : AWS

Highly available Kubernetes cluster
-----------------------------------
Tools used kubespray [Setup k8s cluster], terraform [build infrastrucutre], custom bash script to setup python, Ansible env.
Terraform Infra: terraform will create
  AZ : us-east-2 [all 3 AZs]
  Network: VPC, Subnets (public/private), NAT, IG, Route Table etc..
  EC2 : 1 bastion host with public IP, 3 master nodes, 3 worker node
  EC2 instances are tagged : when you use Kubespray dynamic inventory, you need to tag your master and worker nodes.
    Master nodes tag -- kubespray-role = "kube-master, etcd"
    Worker nodes tag -- kubespray-role = "kube-node"   
 

Prerequits:
  1). AWS account
  2). IAM user with admin permissions
  3). key pair
  
  4). iam profile - for master and worker nodes, so we can provision required resources in k8s like LoadBalancer
      In given terraform i have create 2 IAM role and attached role-policy 
      Master IAM profile - kubeSprayMasterPolicy, Worker IAM profile - kubeSprayWorkerPolicy
      More Info: https://github.com/kubernetes-sigs/kubespray/tree/master/contrib/aws_iam
  
Steps:
 1). Clone this repo
 2). cd terraform folder 
 3). Change values in variables.tf file : access_key, secret_key, key_name [key pair name]
Create a Highly available Kubernetes cluster manually using Google Compute Engines (GCE). Do not create
a Kubernetes hosted solution using Google Kubernetes Engine (GKE). Use Kubeadm(preferred)/kubespray.
Do not use kops.

Setup Jenkins
-------------
Run jenkins as docker container, 
2. Create a CI/CD pipeline using Jenkins (or a CI tool of your choice) outside Kubernetes cluster (not as a pod
inside Kubernetes cluster).
3. Create a development namespace.
4. Deploy guest-book application (or any other application which you think is more suitable to showcase your
ability, kindly justify why you have chosen a different application) in the development namespace.
5. Install and configure Helm in Kubernetes
6. Use Helm to deploy the application on Kubernetes Cluster from CI server.
7. Create a monitoring namespace in the cluster.
8. Setup Prometheus (in monitoring namespace) for gathering host/container metrics along with health
check status of the application.
9. Create a dashboard using Grafana to help visualize the Node/Container/API Server etc. metrices from
Prometheus server. Optionally create a custom dashboard on Grafana
10. Setup log analysis using Elasticsearch, Fluentd (or Filebeat), Kibana.
11. Demonstrate Blue/Green and Canary deployment for the application (For e.g. Change the background
color or font in the new version etc.,)
12. Write a wrapper script (or automation mechanism of your choice) which does all the steps above.
13. Document the whole process in a README file at the root of your repo. Mention any pre-requisites in the
README.
Kubespray, Helm, Jenkins, CI/CI Pipeline, Prometheus, Grafana, Elasticsearch, Fluentd, Kibana, Blue/Green deployment, Terraform
