variable "access_key" {
  description = "AWS ACCEE_KEY"
  default     = "xxxxxxxxxxx"
}

variable "secret_key" {
  description = "AWS SECRETE_KEY"
  default     = "xxxxxxxxxxx"
}

variable "name" {
  default = "k8s"
}

variable "project" {
  default = "k8s-demo"
}

variable "environment" {
  default = "stag"
}

variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  default = "key-pair-name"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "availability_zones" {
  type    = "list"
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "bastion_ami" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "bastion_instance_type" {
  default = "t2.small"
}

variable "master_ami" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "master_instance_type" {
  default = "t2.small"
}

variable "master_instance_count" {
  default = "3"
}
variable "worker_ami" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "worker_instance_type" {
  default = "r4.large"
}

variable "worker_instance_count" {
  default = "3"
}
