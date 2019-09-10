variable "rds_vpc_id" {}
variable "public_access_whitelisted_ips" {
  type    = "list"
  default = []
}
variable "rds_name" {}
variable "rds_instance_class" {}
variable "rds_allocated_storage" {}
variable "rds_db_name" {}
variable "rds_username" {}
variable "rds_password" {}
variable "rds_vpc_database_subnets" {}
variable "rds_vpc_security_group_ids" {}
variable "rds_storage_encrypted" {
  default = false
}
variable "tags" {
  default = {}
}