# Helm charts installation

## Helm v2 setup

### Setup Tiller RBAC
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
```sh
kubectl apply -f helm/helm-rbac.yaml
```

### Install Tiller

```sh
helm init --service-account tiller --tiller-namespace kube-system
```

## kube2iam
```sh
helm upgrade --install "kube2iam" "stable/kube2iam" --version "2.0.1" --namespace "kube-system" \
--set rbac.create="true" \
--set host.interface="eni+" \
--set host.iptables="true"
```

## fluentd-cloudwatch
```sh
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
```

```sh
helm upgrade --install "fluentd-cloudwatch" "incubator/fluentd-cloudwatch" --version "0.10.2" --namespace "kube-system" \
--set rbac.create="true" \
--set awsRegion="eu-west-1" \
--set awsRole="${FLUENTD_CLOUDWATCH_IAM_ROLE_ARN}" \
--set logGroupName="taurus" \
--set extraVars[0]="\{ name: FLUENT_UID\, value: '0' \}"
```

## metrics-server
```sh
helm upgrade --install "metrics-server" "stable/metrics-server" --version "2.8.5" --namespace "kube-system" \
--set replicas="2"
```

## cluster-autoscaler
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

## alb-ingress-controller
```sh
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
```

```sh
helm upgrade --install "aws-alb-ingress-controller" "incubator/aws-alb-ingress-controller" --version "0.1.10" --namespace "kube-system" \
--set clusterName="${EKS_CLUSTER_NAME}" \
--set autoDiscoverAwsRegion="true" \
--set autoDiscoverAwsVpcID="true" \
--set podAnnotations.iam\\.amazonaws\\.com/role="${ALB_INGRESS_CONTROLLER_IAM_ROLE_ARN}"
```

## external-dns
```sh
helm upgrade --install "external-dns" "stable/external-dns" --version "2.6.1" --namespace "kube-system" \
--set rbac.create="true" \
--set replicas="2" \
--set aws.region="eu-west-1" \
--set aws.zoneType="public" \
--set registry="noop" \
--set podAnnotations.iam\\.amazonaws\\.com/role="${EXTERNAL_DNS_IAM_ROLE_ARN}"
```