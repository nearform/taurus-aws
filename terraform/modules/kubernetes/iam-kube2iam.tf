resource "aws_iam_policy" "sts_eks" {
  name = "${var.eks_cluster_name}_kube2iam"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sts_eks" {
  role       = module.eks.worker_iam_role_name
  policy_arn = aws_iam_policy.sts_eks.arn
}