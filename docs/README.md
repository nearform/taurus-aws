# ![Logo][logo-img]

Deploy to AWS with ease using __N__ earForm __O__ pinionated __I__ nfrastructure __S__ tack for __E__ nterprise.

# What is Taurus
Taurus is Terraform infrastructure stack, a boilerplate for any web application.

## High level architecture
![High level architecture][high-level-architecture]

# Explore Taurus
Taurus solves two different problems:
- AWS services provisioning
- Installation of Kubernetes addons

## AWS Services
Taurus focuses on main infrastructure compoments and is exptected to be extended. Thus it's called boilerplate.

The main components are:
- Networking (VPC)
- Kubernetes (EKS + addons IAM roles)
- Database (RDS)
- Static website (S3 + Cloudfront + SSL)

## Kubernetes addons
Same as with infrastructure Taurus focuses only on main and necessary Kubernetes addons. 

### Helm Tiller

There are two parts to Helm: The Helm client (helm) and the Helm server (Tiller).

The tiller is a necessary resource to be able to use helm client and provision applications this manner.
This is what enables us to deploy application from CI in a programmatic way.
And therefore for this setup is a required piece to the puzzle.

For setting up new helmcharts and using the tiller properly there is a best practices that can be found here: [Helm best practices](https://docs.helm.sh/chart_best_practices/)

Documentation for developing helm charts from start to finish can be found here: [Intro to helm charts](https://docs.helm.sh/chart_template_guide/#the-chart-template-developer-s-guide)

### Kube2iam

Provide IAM credentials to containers running inside a kubernetes cluster based on annotations.

Context
Traditionally in AWS, service level isolation is done using IAM roles. IAM roles are attributed through instance profiles and are accessible by services through the transparent usage by the aws-sdk of the ec2 metadata API. When using the aws-sdk, a call is made to the EC2 metadata API which provides temporary credentials that are then used to make calls to the AWS service.

Problem statement
The problem is that in a multi-tenanted containers based world, multiple containers will be sharing the underlying nodes. Given containers will share the same underlying nodes, providing access to AWS resources via IAM roles would mean that one needs to create an IAM role which is a union of all IAM roles. This is not acceptable from a security perspective.

Solution
The solution is to redirect the traffic that is going to the ec2 metadata API for docker containers to a container running on each instance, make a call to the AWS API to retrieve temporary credentials and return these to the caller. Other calls will be proxied to the EC2 metadata API. This container will need to run with host networking enabled so that it can call the EC2 metadata API itself.

For more information and usage see here: [github.com/jtblin/kube2iam](https://github.com/jtblin/kube2iam)


### Fluentd-cloudwatch

Is an open source data collector for unified logging layer.
Fluentd allows you to unify data collection and consumption for a better use and understanding of data.

To learn more about fluentd and its capabilites visit: [docs.fluentd.org](https://docs.fluentd.org/v1.0/articles/quickstart)


[logo-img]: img/Accel_Logo_Taurus.svg
[high-level-architecture]: img/high-level-architecture.jpg

### Metrics-server

Enables collecting of metrics from Kubernetes resources. Metrics-server is a replacement for deprecated `Heapster` metrics collector.

Metrics-server is required for enabling Horizontal Pod Autoscaling (HPA).

To learn more visit: [kubernetes-incubator/metrics-server](https://github.com/kubernetes-incubator/metrics-server)

### Cluster-autoscaler

Cluster Autoscaler is a tool that automatically adjusts the size of the Kubernetes cluster when one of the following conditions is true:
- there are pods that failed to run in the cluster due to insufficient resources
- there are nodes in the cluster that have been underutilized for an extended period of time and their pods can be placed on other existing nodes

To learn more visit: [kubernetes/autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)

### ALB-ingress-controller

The AWS ALB Ingress Controller satisfies Kubernetes ingress resources by provisioning Application Load Balancers.

To learn more visit: [kubernetes-sigs/aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)

### External-dns

ExternalDNS auto-synchronizes exposed Kubernetes Services and Ingresses with DNS providers (AWS Route53).

To learn more visit [kubernetes-incubator/external-dns](https://github.com/kubernetes-incubator/external-dns)