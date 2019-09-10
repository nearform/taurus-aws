data "aws_availability_zones" "azs" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.15.0"

  name = var.vpc_name

  cidr = var.vpc_cidr_block

  azs = data.aws_availability_zones.azs.names

  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_single_nat_gateway ? false : true

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_nat_gateway_route      = false
  create_database_internet_gateway_route = true
  create_database_subnet_route_table     = true

  // Private subnets in your VPC should be tagged accordingly so that 
  // Kubernetes knows that it can use them for internal load balancers
  // https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  private_subnet_tags = {
    Name                                            = "${var.vpc_name}-private"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  public_subnet_tags = {
    Name                                            = "${var.vpc_name}-public"
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  database_subnet_tags = {
    Name = "${var.vpc_name}-db"
  }

  vpc_tags = {
    Name                                            = var.vpc_name
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}