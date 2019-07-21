# DevOps-K8s-Practitioner

Cloud Provider : AWS

Highly available Kubernetes cluster
-----------------------------------
Tools used kubespray [Setup k8s cluster], terraform [build infrastructure], custom bash script to setup prerequisites like python, ansible, kubectl etc..

Terraform module will create:
  - Network: VPC, Subnets (public/private), NAT, IG, Route Table etc in us-east-2 [all 3 AZs]
  - AMI used : ubuntu 18.04
  - EC2 : 1 bastion host with public IP, 3 master nodes, 3 worker nodes
  - EC2 instances are tagged : when we use Kubespray dynamic inventory, we need to tag master and worker nodes.
  	- Master nodes tag -- kubespray-role = "kube-master, etcd"
  	- Worker nodes tag -- kubespray-role = "kube-node"   
 
Prerequisites:
  - AWS account
  - IAM user with admin rights
  - key pair
  - iam profile - for master and worker nodes, we need this to provision required resources in k8s like LoadBalancer
      - In given terraform we have create 2 IAM roles and attached role-policy 
      - Master IAM profile - kubeSprayMasterPolicy, Worker IAM profile - kubeSprayWorkerPolicy
      - More Info: https://github.com/kubernetes-sigs/kubespray/tree/master/contrib/aws_iam
      - Check kubernetes-role-policy folder in this repo.
  

# Highly available Kubernetes cluster using kubespray on AWS cloud.

Step 1:
- cd terraform-aws-vpc-bastion
- Follow README.md

Step 2:
- cd python-ansible-docker
- Follow README.md

Step 3:
- cd kubespray
- Follow README.md

# Create a CI/CD pipeline using Jenkins outside Kubernetes cluster (not as a pod inside Kubernetes cluster).
Runnig jenkins as docker container on bastion host
- cd jenkins
- Follow README.md


# Deploy guest-book application in the development namespace.
Will use Jenkins pipeline to deploy guest-book app in development namespace
- cd guestbook
- Follow README.md

# Install and configure Helm in Kubernetes
- cd installHelm
- Follow README.md

# Use Helm to deploy the application on Kubernetes Cluster from CI server.
- Grafana, Prometheus and EFK deployed using Helm

# Setup Prometheus (in monitoring namespace) for gathering host/container metrics along with health check status of the application.
- cd installPrometheusGrafana
- Follow README.md

# Create a dashboard using Grafana to help visualize the Node/Container/API Server etc. metrices from Prometheus server. Optionally create a custom dashboard on Grafana
- cd grafanaDashboard
- Follow README.md

# Setup log analysis using Elasticsearch, Fluentd (or Filebeat), Kibana.
- Used helm to install EFK stack
- cd installEFK
- Follow README.md

# Demonstrate Blue/Green and Canary deployment for the application 
To demonstrate Blue/Green deployment I have created a single page Node.js app, listen on <lb>:8080 URL and display "Welcome BLUE!" in case blue deployment, and "Welcome GREEN!" in case green. [edit src/index.js file]
- https://github.com/sunnynew/blueGreen.git

