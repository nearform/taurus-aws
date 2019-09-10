output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

output "alb_ingress_controller_iam_role_arn" {
  value = "${aws_iam_role.alb_ingress_controller.arn}"
}

output "external_dns_iam_role_arn" {
  value = "${aws_iam_role.external_dns.arn}"
}

output "cluster_autoscaler_iam_role_arn" {
  value = "${aws_iam_role.cluster_autoscaler.arn}"
}

output "fluentd_cloudwatch_iam_role_arn" {
  value = "${aws_iam_role.fluentd_cloudwatch.arn}"
}