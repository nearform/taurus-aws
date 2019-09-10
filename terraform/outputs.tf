output "kubernetes_cluster_name" {
  value = module.kubernetes.eks_cluster_id
}
output "kubernetes_alb_ingress_controller_iam_role_arn" {
  value = module.kubernetes.alb_ingress_controller_iam_role_arn
}

output "kubernetes_external_dns_iam_role_arn" {
  value = module.kubernetes.external_dns_iam_role_arn
}

output "kubernetes_cluster_autoscaler_iam_role_arn" {
  value = module.kubernetes.cluster_autoscaler_iam_role_arn
}

output "kubernetes_fluentd_cloudwatch_iam_role_arn" {
  value = module.kubernetes.fluentd_cloudwatch_iam_role_arn
}