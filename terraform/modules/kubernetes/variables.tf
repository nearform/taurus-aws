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
variable "eks_map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    role_arn  = string
    username = string
    group   = list(string)
  }))
  default = []
}
variable "tags" {
  default = {}
}