# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}
variable "aws_region" {
  default = "ap-southeast-2"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "subnets_cidr" {
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "azs" {
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}


