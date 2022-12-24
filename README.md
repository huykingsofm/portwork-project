# portwork-project
Introduction to portworx - Kubernetes storage platform

## **AWS**

### 1. Create a new kubernetes cluster (3-node) in AWS

#### Prerequisites
- an AWS account
- kubectl (v1.24.0 or newer)
- aws-cli (tested on v1.27.35): a cli tool to interact with AWS services.
- terraform (test on v1.2.7): an Infras-as-code tool that let us build, change cloud and on-prem resources

#### Clone this repository:
  git clone https://github.com/huynhminhchu/portwork-project.git


















# Terraform oracle provider
- 1.Get tenancy_ocid = ""
- 2.Get user ocid = "" 
- 3.1 Generate an api signing key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two
  openssl genrsa -out private_key.pem -aes128 2048
  chmod go-rwx private_key.pem
  openssl rsa -pubout -in private_key.pem -out public_key.pem

    When you upload your public key to the identity control plane, you get a key ID in return:
    The key format is tenantId/userId/fingerprint.
    Or we can generate again: 


# Create eks cluster in aws
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

or aws configure


aws eks update-kubeconfig --name portwork-cluster --region us-west-2
kubectl edit configmap aws-auth -n kube-system

mapUsers: |
  - userarn: arn:aws:iam::[account_id]:root
    groups:
    - system:masters


kubectl apply -f 'https://install.portworx.com/2.12?comp=pxoperator&kbver=1.23.13-eks-fb459a0&ns=portworx'

kubectl apply -f 'https://install.portworx.com/2.12?operator=true&mc=false&kbver=1.23.13-eks-fb459a0&ns=portworx&oem=esse&user=691b8f86-9efb-42d1-8927-7036c46cae7d&b=true&s=%2Fdev%2Fnvme2n1&j=auto&kd=type%3Dgp2%2Csize%3D150&c=px-cluster-aa66e19e-b848-44a6-9ea3-30b12c14383b&eks=true&stork=true&csi=true&mon=true&tel=false&st=k8s&promop=true'

PX_POD=$(kubectl get pods -l name=portworx -n portworx -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $PX_POD -n portworx -- /opt/pwx/bin/pxctl status