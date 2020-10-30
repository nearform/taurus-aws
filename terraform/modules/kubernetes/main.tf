data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "13.0.0"
  cluster_name              = var.eks_cluster_name
  vpc_id                    = var.eks_vpc_id
  subnets                   = var.eks_vpc_private_subnets
  cluster_version           = var.eks_cluster_version
  cluster_enabled_log_types = [] # https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  config_output_path        = "${path.root}/"
  write_kubeconfig          = false

  worker_groups = [
    {
      ami_id                = var.eks_worker_ami_id
      instance_type         = var.eks_worker_instance_type
      asg_max_size          = var.eks_worker_node_max_size
      asg_min_size          = var.eks_worker_node_min_size
      asg_desired_capacity  = var.eks_worker_node_min_size
      autoscaling_enabled   = true
      protect_from_scale_in = false
    },
  ]

  map_users = var.eks_map_users

  tags = var.tags
}