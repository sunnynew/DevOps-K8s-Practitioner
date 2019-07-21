#
# VPC resources
#
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.name}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name        = "PrivateRouteTable"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    "kubernetes.io/cluster/cluster.local" = ""
  }
}

resource "aws_route" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.default.*.id, count.index)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name        = "PublicRouteTable"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    "kubernetes.io/cluster/cluster.local" = ""
  }
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${element(var.private_subnet_cidr_blocks, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name        = "PrivateSubnet"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    "kubernetes.io/cluster/cluster.local" = ""
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${element(var.public_subnet_cidr_blocks, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "PublicSubnet"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    "kubernetes.io/role/elb" = ""
    "kubernetes.io/cluster/cluster.local" = ""
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

#resource "aws_vpc_endpoint" "s3" {
#  vpc_id          = "${aws_vpc.default.id}"
#  service_name    = "com.amazonaws.${var.region}.s3"
#  route_table_ids = ["${aws_route_table.public.id}", "${aws_route_table.private.*.id}"]
#}

#
# NAT resources
#

resource "aws_eip" "nat" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  vpc = true
}

resource "aws_nat_gateway" "default" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  depends_on = ["aws_internet_gateway.default"]
}

#
# Bastion resources
#

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
 }

  tags {
    Name        = "sgBastion"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}



resource "aws_network_interface_sg_attachment" "bastion" {
  security_group_id    = "${aws_security_group.bastion.id}"
  network_interface_id = "${aws_instance.bastion.primary_network_interface_id}"
}

resource "aws_instance" "bastion" {
  ami                         = "${var.bastion_ami}"
  availability_zone           = "${element(var.availability_zones, 0)}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = false
  subnet_id                   = "${element(aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true
  iam_instance_profile        = "terraform-admin-user"

  tags {
    Name        = "Bastion"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

# K8s Master and Worker nodes resources
#

resource "aws_security_group" "k8s" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
 }

  tags {
    Name        = "sgKubernetes"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

# Comment out as we are not giving public IP to master nodes
#resource "aws_network_interface_sg_attachment" "k8s" {
#  security_group_id    = "${aws_security_group.k8s.id}"
#  network_interface_id = "${aws_instance.master.primary_network_interface_id}"
#}

resource "aws_instance" "master" {
  count         	      = "${var.master_instance_count}"
  ami                         = "${var.master_ami}"
  availability_zone	      = "${element(var.availability_zones, count.index)}"
  instance_type               = "${var.master_instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = false
  security_groups	      = ["${aws_security_group.k8s.id}"]
  subnet_id                   = "${element(aws_subnet.private.*.id, count.index)}"
  associate_public_ip_address = false
  iam_instance_profile	      = "kubeSprayMasterPolicy"
  tags {
    Name        = "master-${count.index + 1}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    kubespray-role = "kube-master, etcd"
    "kubernetes.io/cluster/cluster.local" = ""
  }
}

resource "aws_instance" "worker" {
  count                       = "${var.worker_instance_count}"
  ami                         = "${var.worker_ami}"
  availability_zone           = "${element(var.availability_zones, count.index)}"
  instance_type               = "${var.worker_instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = false
  security_groups             = ["${aws_security_group.k8s.id}"]
  subnet_id                   = "${element(aws_subnet.private.*.id, count.index)}"
  associate_public_ip_address = false
  iam_instance_profile	      = "kubeSprayWorkerPolicy"

  tags {
    Name        = "worker-${count.index + 1}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    kubespray-role = "kube-node"
    "kubernetes.io/cluster/cluster.local" = ""
  }
}
