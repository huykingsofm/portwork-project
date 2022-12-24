# portwork-project
A portwork project

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

kubectl apply -f 'https://install.portworx.com/2.12?operator=true&mc=false&kbver=1.23.13-eks-fb459a0&ns=portworx&oem=esse&user=691b8f86-9efb-42d1-8927-7036c46cae7d&b=true&s=%2Fdev%2Fnvme2n1&j=auto&c=px-cluster-f51556dd-183a-4880-b19d-9542027f9925&stork=true&csi=true&mon=true&tel=false&st=k8s&promop=true'

PX_POD=$(kubectl get pods -l name=portworx -n portworx -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $PX_POD -n portworx -- /opt/pwx/bin/pxctl status