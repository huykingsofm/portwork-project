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


kubectl delete -f 'https://install.portworx.com/2.12?comp=pxoperator&kbver=1.23.13&ns=portworx'

kubectl delete -f 'https://install.portworx.com/2.12?operator=true&mc=false&kbver=1.23.13&ns=portworx&oem=esse&user=691b8f86-9efb-42d1-8927-7036c46cae7d&b=true&kd=type%3Dgp2%2Csize%3D150&s=%22type%3Dgp2%2Csize%3D150%22&j=auto&c=px-cluster-b5510509-c0e6-4654-9e1b-d08ad30f46e8&eks=true&stork=true&csi=true&mon=true&tel=false&st=k8s&promop=true'