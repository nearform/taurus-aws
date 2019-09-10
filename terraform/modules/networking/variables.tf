variable "vpc_name" {}
variable "eks_cluster_name" {}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "vpc_public_subnets" {
  type    = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "vpc_private_subnets" {
  type    = "list"
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "vpc_database_subnets" {
  type    = "list"
  default = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}
variable "vpc_single_nat_gateway" {
  default = true
}