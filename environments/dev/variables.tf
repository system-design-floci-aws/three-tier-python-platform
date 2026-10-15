variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "three-tier"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "private_app_subnets" { type = list(string) }
variable "private_db_subnets" { type = list(string) }

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
