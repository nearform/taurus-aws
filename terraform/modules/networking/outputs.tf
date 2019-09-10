output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_database_subnets" {
  value = module.vpc.database_subnets
}

output "vpc_default_security_group_id" {
  value = module.vpc.default_security_group_id
}