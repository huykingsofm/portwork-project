# portwork-project
Introduction to portworx - Kubernetes storage platform

## **AWS**

### 1. Create a new kubernetes cluster (3-node) in AWS

#### Prerequisites:
- an AWS account
- kubectl (v1.24.0 or newer)
- aws-cli (tested on v1.27.35): a cli tool to interact with AWS services.
- terraform (test on v1.2.7): an Infras-as-code tool that let us build, change cloud and on-prem resources

#### Clone this repository:
    git clone https://github.com/huynhminhchu/portwork-project.git

#### Configure the AWS credential:
For the terraform code to work, we need to authenticate it with AWS. There are different ways to do this but for demonstration we will use the [shared configuration and credentials files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html). By default, these files are located at $HOME/.aws/config and $HOME/.aws/credentials.
Run the following command to set up AWS credential
    aws configure
Enter your credentials (AWS Access Key ID and AWS Secret Access Key) and region.

#### Provisioning the EKS cluster
    cd infrastructure
    # Init: terraform will download defined modules
    terraform init
    # Create infras
    terraform apply --auto-approve
Terraform will provision a 3-node kubernetes cluster in AWS as the following diagram:
![AWS EKS Portwork](/images/aws_portwork.png)

##### What to note:
First, in 1-vpc.tf we create a VPC in AWS with a CIDR range of 10.1.0.0/16, 3 public subnets and 3 private subnets across 3 AZs (us-west-2a, us-west-2b, us-west-2c).
Then we initialize an EKS cluster in 2-eks-master.tf and assign the control plane a role with enough permission
After that, in 3-eks-workers.tf we create 3 nodes in the EKS cluster and provide them the required permissions for portworx:
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "", 
            "Effect": "Allow",
            "Action": [
              "ec2:AttachVolume",
              "ec2:ModifyVolume",
              "ec2:DetachVolume",
              "ec2:CreateTags",
              "ec2:CreateVolume",
              "ec2:DeleteTags",
              "ec2:DeleteVolume",
              "ec2:DescribeTags",
              "ec2:DescribeVolumeAttribute",
              "ec2:DescribeVolumesModifications",
              "ec2:DescribeVolumeStatus",
              "ec2:DescribeVolumes",
              "ec2:DescribeInstances",
              "autoscaling:DescribeAutoScalingGroups"
            ],
            "Resource": [
              "*"
            ]
          }
        ]
      }
We should also add a policy to allow SSM connection to worker nodes (for debugging):
      resource "aws_iam_role_policy_attachment" "ssm_policy" {
        role       = aws_iam_role.worker_role.name
        policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
Finally don't forget to add a new disk to use in portworx:
      block_device_mappings {
        device_name = "/dev/sdh"
        ebs {
          volume_size           = 50
          delete_on_termination = true
        }
      }
#### 




















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