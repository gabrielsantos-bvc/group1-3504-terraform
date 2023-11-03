terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }

	backend "s3" {
		bucket = "group1-3504-project"
		key = "tfstate/terraform.tfstate"
		region = "us-east-1"
	}
}

# Provider
provider "aws" {
  region  = var.region
}

resource "aws_instance" "aws_ubuntu" {
  instance_type = "t2.micro"
  ami = "ami-052efd3df9dad4825"
  key_name = var.key_name
  user_data = file("userdata.tpl")

	tags = {
    Name = var.instance_name
  }
}  


# Default VPC
resource "aws_default_vpc" "default" {

}

# Security group
resource "aws_security_group" "group1_3504_sg" {
  name        = "group1_3504_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}