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

variable "instance_types" {
  type    = list(string)
  default = ["t2.micro", "t2.micro", "t2.micro"]
}

variable "key_names" {
  type    = list(string)
  default = ["terraform-aws", "terraform-aws", "terraform-aws"]
}

resource "aws_instance" "example" {
  count = 3

  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = var.instance_types[count.index]
  key_name               = var.key_names[count.index]
  vpc_security_group_ids = ["sg-0c51540c60857b7ed"]
  subnet_id              = "subnet-096d45c28d9fb4c14"

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name      = "vm-${count.index + 1}"
    Create_By = "Terraform"
  }
}


