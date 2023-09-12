variable "region" {
  type        = string
  description = "The region to use"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "The vpc cidr block"
  default     = "10.0.0.0/24"
}

variable "public_subnet" {
  type = object({
    az   = string
    cidr = string
  })
  description = "An object containing public subnet details"
  default = {
    az   = "us-east-1a"
    cidr = "10.0.0.0/25"
  }
}

variable "private_subnet" {
  type = object({
    az   = string
    cidr = string
  })
  description = "An object containing private subnet details"
  default = {
    az   = "us-east-1b"
    cidr = "10.0.0.128/25"
  }
}

variable "instance_type" {
  type        = string
  description = "The instance type to create"
  default     = "t2.micro"
}

variable "ami" {
  type        = string
  description = "The ami to use"
  default     = "ami-01c647eace872fc02"
}

