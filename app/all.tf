#######
# main.tf
######
resource "aws_network_interface" "main" {
  subnet_id       = var.subnet_id
  security_groups = var.security_groups

  tags = {
    Name = "ubuntu-eni"
  }
}

resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = var.key_pair_name
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnet_id
  primary_network_interface = {
    network_interface_id = 
  }
  tags = {
    Name = var.instance_name
  }
}

#########
## Output.tf
#########

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

#########
# Provider.tf
########
# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile= "stage"
}

##############
# variables.tf
############
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "demo-web-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for SSH access"
  type        = string
  default     = "ansible-test"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0360c520857e3138f"  # ubuntu24
}

variable "security_groups"{
  type = list(string)
  default = ["sg-0fc5e7a0917c11c50"]
  description = "Enter security group ids"
}

variable "subnet_id" {
  type = "string"
  description = "Enter the subnet id"
  default = "subnet-037949bf6b411e4b5"
}

