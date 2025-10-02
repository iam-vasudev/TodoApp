variable "region" {
description = "AWS region"
type = string
default = "us-east-1"
}


variable "vpc_cidr" {
description = "VPC CIDR block"
type = string
default = "10.0.0.0/16"
}


variable "public_subnets" {
description = "List of public subnet CIDRs"
type = list(string)
default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "instance_type" {
description = "EC2 instance type"
type = string
default = "t3.micro"
}


variable "key_name" {
description = "SSH key pair name (optional)"
type = string
default = ""
}


variable "ecr_repo_name" {
description = "ECR repository name"
type = string
default = "todoapp"
}