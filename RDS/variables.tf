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
  default = "10.0.0.0/16"
}

variable "subnets_cidr" {
  default = ["10.0.1.0/24", "10.1.2.0/24"]
}

variable "azs" {
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "rds_instance_identifier" {
  default = "rds-mysql"
}
variable "database_name" {
  default = "rdstestdb"
}
variable "database_password" {
  description = "RDS database password"
}
variable "database_user" {
  default = "terraform"
}

