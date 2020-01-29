# Install Kubernetes Add-Ons 

Use Helm to install Kubernetes add-ons. Helm, the package manager for Kubernetes, is a useful tool to install, upgrade and manage applications on a Kubernetes cluster. Helm packages are called charts. 

Helm consists of a client (helm) and a server (Tiller). Tiller runs inside your Kubernetes cluster as a pod in the kube-system namespace. Tiller manages both the releases (installations) and revisions (versions) of charts deployed on the cluster. When you run Helm commands, your local Helm client sends instructions to the Tiller in the cluster that then makes the requested changes.

## Configure Helm 

### 1. Configure Helm Tiller Role-Based Access Control(RBAC)
To create a new Helm service account (tiller) and limit Tiller access to the Tiller namespace (kube-system) within the cluster, you need to configure Tiller RBAC.

Edit the file `helm/helm-rbac.yaml` so that it contains the following configuration:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```
Apply the configuration using the following command:
```sh
kubectl apply -f helm/helm-rbac.yaml
```

### 2. Install Tiller

Install Tiller to manage the cluster Helm charts using the command:
```sh
helm init --service-account tiller --tiller-namespace kube-system
```

You can verify that you have the correct version and that it installed properly using the command: 
```sh
helm version
```

## Install kube2iam
Install kube2iam using the following command:
```sh
helm upgrade --install "kube2iam" "stable/kube2iam" --version "2.0.1" --namespace "kube-system" \
--set rbac.create="true" \
--set host.interface="eni+" \
--set host.iptables="true"
```

## Install Fluentd CloudWatch
Add the Helm incubator charts repository for your local client using the following command:
```sh
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
```
Install FluentD CloudWatch to the namespace 'kube-system' using the following command:
```sh
helm upgrade --install "fluentd-cloudwatch" "incubator/fluentd-cloudwatch" --version "0.10.2" --namespace "kube-system" \
--set rbac.create="true" \
--set awsRegion="eu-west-1" \
--set awsRole="${FLUENTD_CLOUDWATCH_IAM_ROLE_ARN}" \
--set logGroupName="taurus" \
--set extraVars[0]="\{ name: FLUENT_UID\, value: '0' \}"
```

## Install Metrics Server
Use the following command to install metrics server:
```sh
helm upgrade --install "metrics-server" "stable/metrics-server" --version "2.8.5" --namespace "kube-system" \
--set replicas="2"
```

## Install Cluster Autoscaler
Use the following command to install and configure the cluster autoscaler:

```sh
helm upgrade --install "cluster-autoscaler" "stable/cluster-autoscaler" --version "3.2.0" --namespace "kube-system" \
--set rbac.create="true" \
--set replicaCount="2" \
--set sslCertPath="/etc/ssl/certs/ca-bundle.crt" \
--set cloudProvider="aws" \
--set autoDiscovery.enabled="true" \
--set autoDiscovery.clusterName="${EKS_CLUSTER_NAME}" \
--set awsRegion="eu-west-1" \
--set podAnnotations.iam\\.amazonaws\\.com/role="${CLUSTER_AUTOSCALER_IAM_ROLE_ARN}"
```

## Install Application Load Balancer
The Application Load Balancer (ALB) is alb-ingress-controller. Use the following command to add to the repository:
```sh
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
```
Install and configure the ALB using the command:
```sh
helm upgrade --install "aws-alb-ingress-controller" "incubator/aws-alb-ingress-controller" --version "0.1.10" --namespace "kube-system" \
--set clusterName="${EKS_CLUSTER_NAME}" \
--set autoDiscoverAwsRegion="true" \
--set autoDiscoverAwsVpcID="true" \
--set podAnnotations.iam\\.amazonaws\\.com/role="${ALB_INGRESS_CONTROLLER_IAM_ROLE_ARN}"
```

## Install ExternalDNS
Use the following command to install and configure ExternalDNS:
```sh
helm upgrade --install "external-dns" "stable/external-dns" --version "2.6.1" --namespace "kube-system" \
--set rbac.create="true" \
--set replicas="2" \
--set aws.region="eu-west-1" \
--set aws.zoneType="public" \
--set registry="noop" \
--set podAnnotations.iam\\.amazonaws\\.com/role="${EXTERNAL_DNS_IAM_ROLE_ARN}"
```