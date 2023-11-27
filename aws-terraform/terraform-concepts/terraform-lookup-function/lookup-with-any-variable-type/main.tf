terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "instance_configs" {
  type = any
  default = {
    ami                    = "ami-0fc5d935ebf8bc3bc"
    instance_type          = "t2.micro"
    key_name               = "terraform-aws"
    vpc_security_group_ids = []
    subnet_id              = null
    volume_size            = "10"
    tags = {
      "id"             = "2560"
      "owner"          = "DevOps Easy Learning"
      "teams"          = "DEL"
      "environment"    = "dev"
      "project"        = "del"
      "create_by"      = "Terraform"
      "cloud_provider" = "aws"
    }
  }
}


resource "aws_instance" "example" {
  ami                    = lookup(var.instance_configs, "ami", "ami-0fc5d935ebf8bc3bc")
  instance_type          = lookup(var.instance_configs, "instance_type", "t2.micro")
  key_name               = lookup(var.instance_configs, "key_name", "terraform-aws")
  vpc_security_group_ids = lookup(var.instance_configs, "vpc_security_group_ids", [])
  subnet_id              = lookup(var.instance_configs, "subnet_id", null)

  root_block_device {
    volume_size = lookup(var.instance_configs, "volume_size", "10")
  }

  tags = merge(lookup(var.instance_configs, "tags", {}), {
    Name = format("%s-%s-%s-vm", lookup(var.instance_configs["tags"], "id", ""), lookup(var.instance_configs["tags"], "environment", ""), lookup(var.instance_configs["tags"], "project", ""))
  })
}

