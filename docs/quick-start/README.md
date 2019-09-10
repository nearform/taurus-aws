# Quick Start

## Install dependencies
1. Install [aws][aws-cli-install] CLI
2. Install [aws-iam-authenticator][aws-iam-authenticator-install]
3. Install [kubectl][kubectl-install]
4. Install [helm][helm-install] 
  * Once helm is installed execute: `helm init --client-only`
4. Install [terraform][terraform-install] client version: >= 0.12.8

## AWS prerequisites

### Terraform IAM user
1. Create an access keys of a user with right permissions for provisioning this list of components:
  * VPC (with subnets, etc...)
  * EKS cluster
  * RDS (PostgreSQL DB)
  * S3 bucket for serving static content
  * Cloudfront CDN for S3 bucket
3. Create an AWS profile that makes use of access key created in previous step by running command:
  ```sh
  $ aws configure --profile taurus
  ```
  
  Output will guide you thru it like this
  ```sh
  AWS Access Key ID [None]: AK*********E
  AWS Secret Access Key [None]: je7M***************EY
  Default region name [None]: eu-west-1
  Default output format [None]: text
  ```

4. Set AWS CLI to use `taurus` AWS profile by setting this environment variable:
  ```sh
  export AWS_PROFILE=taurus
  ```

[kubectl-install]: https://kubernetes.io/docs/tasks/tools/install-kubectl
[aws-iam-authenticator-install]: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
[helm-install]: https://github.com/helm/helm/releases/tag/v2.9.0
[terraform-install]: https://www.terraform.io/downloads.html
[aws-cli-install]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

### Terraform state S3 bucket
1. Create a S3 Bucket:
```sh
aws s3api create-bucket \
--bucket taurus-terraform-state \
--region eu-west-1 \
--create-bucket-configuration LocationConstraint=eu-west-1
```
2. Enable versioning on the bucket:
```sh
aws s3api put-bucket-versioning \
--bucket taurus-terraform-state \
--versioning-configuration Status=Enabled
```

## Provisioning
1. Rename and adjust `backend.tfvars.sample` to `backend.tfvars` (terraform backend storage configuration)
2. Rename and adjust `config.tfvars.sample` to `development.tfvars` (terraform project configuration)
3. Init Terraform:
```sh
terraform init -backend-config=backend.tfvars
```
4. Create and switch to right workspace (environment):
```sh
terraform workspace new development
```
5. Provision the infrastructure:
```sh
terraform apply -var-file="development.tfvars"
```
6. Once the Kubernetes cluster exists you can fetch & update your `~/.kube/config`.
```sh
aws eks update-kubeconfig --name <eks_cluster_name>
```
7. Install Kubernetes addons [Step by Step guide](/helm/)

## Access to Kubernetes
Only AWS IAM user who provisioned the stack has access to Kubernetes cluster.
New users can be added by setting up `eks_map_users` optional variable in `kubernetes` Terraform module.
```hcl
eks_map_users = [
  {
    user_arn = "arn:aws:iam::506174623202:user/petr"
    username = "petr"
    group    = "system:masters"
  }
]
```
More info: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
