terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.15.0"
    }
  }
}

provider "aws" {
  region = var.region
}


resource "aws_s3_bucket" "data" {
  bucket = local.s3_bucket_name

  tags = {
    Name = "s3-data-bt"
  }
}

resource "aws_iam_instance_profile" "instance" {
  name = "ec2instance"
  role = aws_iam_role.instance.name
}


resource "aws_instance" "instance" {
  subnet_id            = aws_subnet.private.id
  iam_instance_profile = aws_iam_instance_profile.instance.name
  instance_type        = var.instance_type
  ami                  = var.ami
  
  ebs_block_device {
    device_name = local.ebs_device_name
    volume_type = "gp2"
    encrypted   = true
    volume_size = 100

    tags = {
      Name = "instance-ebs"
    }
  }
}
