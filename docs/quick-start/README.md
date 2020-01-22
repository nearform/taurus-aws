# Taurus Quick Start Guide

This section describes how to get started with Taurus. It outlines the following:
 - Taurus dependencies you need to install. 
 - How to clone the Taurus repository. 
 - AWS prerequisites you require.
 - Details on how to provision Terraform.

## Install Dependencies
Install the following Taurus dependencies using the instructions in each provided link:

1. [AWS][aws-cli-install] CLI
1. [aws-iam-authenticator][aws-iam-authenticator-install]
1. [kubectl][kubectl-install]
1. [Helm][helm-install] 
    
    After installing Helm, run the command: 
    
    `helm init --client-only`
1. [Terraform][terraform-install]. Use version 0.12.8 or higher.

## Clone the Source Repository
To start, fork [Taurus] on GitHub. It is easier to maintain your own fork as Taurus is designed to diverge. It is unlikely you will need to pull from the source repository again.

Once you have your fork, clone a copy of it locally:

```sh
git clone https://github.com/<your-fork>/taurus.git
```

## AWS Prerequisites

Amazon Web Services(AWS) requires:
- A Terraform IAM user with access keys and an AWS profile.
- A Terraform S3 bucket.

This section describes how to create both of these.

### Create a Terraform IAM User
1. Create an access key for a user with right permissions for provisioning this list of components:
    * VPC (with subnets and so on)
    * EKS cluster
    * RDS (PostgreSQL DB)
    * S3 bucket to serve static content
    * CloudFront Content Delivery Network (CDN) for the S3 bucket

1. Create an AWS profile that uses the access key created in the previous step by running command:
    ```sh
    $ aws configure --profile taurus
    ```
  
    The output guides you through the profile setup as follows:
    ```sh
    AWS Access Key ID [None]: AK*********E
    AWS Secret Access Key [None]: je7M***************EY
    Default region name [None]: eu-west-1
    Default output format [None]: text
    ```

1. Set the AWS CLI to use the taurus AWS profile using the `AWS_PROFILE` environment variable as follows:
    ```sh
    export AWS_PROFILE=taurus
    ```

### Create a Terraform State S3 Bucket
1. Create a S3 Bucket using the following command:
    ```sh
    aws s3api create-bucket \
    --bucket taurus-terraform-state \
    --region eu-west-1 \
    --create-bucket-configuration LocationConstraint=eu-west-1
    ```
1. Enable versioning on the bucket using the following command:
    ```sh
    aws s3api put-bucket-versioning \
    --bucket taurus-terraform-state \
    --versioning-configuration Status=Enabled
    ```

## Provision Terraform
1. Rename and and edit the Terraform backend storage configuration file from `backend.tfvars.sample` to `backend.tfvars`.
1. Rename and edit the Terraform project configuration file from  `config.tfvars.sample` to `development.tfvars`.
1. Initialise Terraform using the command:
    ```sh
    terraform init -backend-config=backend.tfvars
    ```
1. Create and switch to the right workspace (environment):
    ```sh
    terraform workspace new development
    ```
1. Provision the infrastructure:
    ```sh
    terraform apply -var-file="development.tfvars"
    ```
1. When the Kubernetes cluster exists, fetch and update the `~/.kube/config` file.
    ```sh
    aws eks update-kubeconfig --name <eks_cluster_name>
    ```
1. Install Kubernetes add-ons.
See the [Install Kubernetes Add-Ons] section of this document for more details. 

## Create Users with Access to Kubernetes
Only the AWS IAM user who provisioned the stack has access to the Kubernetes cluster.

To add a new user, use the `eks_map_users` optional variable in the Kubernetes Terraform module. For example:

```hcl
eks_map_users = [
  {
    user_arn = "arn:aws:iam::506174623202:user/petr"
    username = "petr"
    group    = "system:masters"
  }
]
```

For more information on adding users, refer to [Managing Users or IAM Roles for your Cluster].

<!-- Internal Links -->
[Install Kubernetes Add-Ons]:/helm/

<!-- External Links -->
[aws-cli-install]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
[aws-iam-authenticator-install]: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
[kubectl-install]: https://kubernetes.io/docs/tasks/tools/install-kubectl
[helm-install]: https://github.com/helm/helm/releases/tag/v2.9.0
[terraform-install]: https://www.terraform.io/downloads.html
[Managing Users or IAM Roles for your Cluster]: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
[Taurus]: https://github.com/nearform/taurus
