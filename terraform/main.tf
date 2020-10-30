module "networking" {
  source = "./modules/networking"

  vpc_name         = "${var.project_name}-${terraform.workspace}"
  eks_cluster_name = "${var.project_name}-${terraform.workspace}"
}

module "kubernetes" {
  source = "./modules/kubernetes"

  eks_cluster_name         = "${var.project_name}-${terraform.workspace}"
  eks_vpc_id               = module.networking.vpc_id
  eks_vpc_private_subnets  = module.networking.vpc_private_subnets
  eks_cluster_version      = var.eks_cluster_version
  eks_worker_ami_id        = var.eks_worker_ami_id
  eks_worker_instance_type = var.eks_worker_instance_type
}

module "database" {
  source = "./modules/database"

  rds_name                   = "${var.project_name}-${terraform.workspace}"
  rds_instance_class         = var.rds_instance_class
  rds_allocated_storage      = var.rds_allocated_storage
  rds_db_name                = var.rds_db_name
  rds_username               = var.rds_username
  rds_vpc_id                 = module.networking.vpc_id
  rds_vpc_security_group_ids = [module.networking.vpc_default_security_group_id, module.kubernetes.eks_worker_security_group_id]
  rds_vpc_database_subnets   = module.networking.vpc_database_subnets
}

module "static_website" {
  source = "./modules/static-website"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  route53_hosted_zone = var.route53_hosted_zone
  domain_name         = var.static_website_domain_name
}