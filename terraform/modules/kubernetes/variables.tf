variable "eks_cluster_name" {}
variable "eks_vpc_id" {}
variable "eks_vpc_private_subnets" {}
variable "eks_cluster_version" {}
variable "eks_worker_node_min_size" {
  default = 2
}
variable "eks_worker_node_max_size" {
  default = 4
}
variable "eks_worker_ami_id" {}
variable "eks_worker_instance_type" {}
variable "eks_map_users" {
  type    = "list"
  default = []
}
variable "tags" {
  default = {}
}