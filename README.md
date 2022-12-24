# **Portwork-project**
Introduction to portworx - Kubernetes storage platform

## **AWS**
### Contents
[Provision EKS cluster using Terraform](https://github.com/huynhminhchu/portwork-project#eks-cluster)

[Deploy portworx operator on EKS cluster](https://github.com/huynhminhchu/portwork-project#deploy-px)

[Create your first PVC](https://github.com/huynhminhchu/portwork-project#use-px)

[Clean up resources](https://github.com/huynhminhchu/portwork-project#cleanup)
### [1. Create a new kubernetes cluster (3-node) in AWS](#eks-cluster)

#### Prerequisites:
- an AWS account
- kubectl (v1.24.0 or newer)
- aws-cli (tested on v1.27.35): a cli tool to interact with AWS services.
- terraform (test on v1.2.7): an Infras-as-code tool that let us build, change cloud and on-prem resources

#### Clone this repository:
    git clone https://github.com/huynhminhchu/portwork-project.git

#### Configure the AWS credential:
For the terraform code to work, we need to authenticate it with AWS.  
There are different ways to do this but for demonstration we will use the [shared configuration and credentials files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).  
By default, these files are located at $HOME/.aws/config and $HOME/.aws/credentials.  
Run the following command to set up AWS credential:  

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

##### *What to note*:
First, in 1-vpc.tf we create a VPC in AWS with a CIDR range of 10.1.0.0/16, 3 public subnets and 3 private subnets across 3 AZs (us-west-2a, us-west-2b, us-west-2c).  
Then we initialize an EKS cluster in 2-eks-master.tf and assign the control plane a role with enough permission.  
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

Wait for the EKS cluster to be up then configure the kubectl: 

      aws eks update-kubeconfig --name portwork-cluster --region us-west-2
### [2. Deploy portworx on the EKS cluster](#deploy-px)
- Navigate to the Portworx [spec generator](https://central.portworx.com/specGen/wizard)  
- Select Portworx Essentials and Continue.  
- Tick on use the portworx operator, choose portworx v2.12 and specify Kubernete version (1.23.13-eks-fb459a0):  
![Basic setting](/images/basic_setting.PNG)
- Select AWS Cloud Platform and leave everything as default (or we can specify existing disks):
![AWS EKS Portwork](/images/storage_setting.PNG)
- Leave network setting as default:
![Network setting](/images/network_setting.PNG)
- Under the Customize tab, select Amazon EKS option and Finish:
![Network setting](/images/customize_setting.PNG)

- Install the Portworx Operator Deployment Spec and wait for it to be operational:
      
      kubectl apply -f 'https://install.portworx.com/2.12?comp=pxoperator&kbver=1.23.13-eks-fb459a0&ns=portworx'

  <!-- tsk -->

      kubectl apply -f 'https://install.portworx.com/2.12?operator=true&mc=false&kbver=1.23.13-eks-fb459a0&ns=portworx&oem=esse&user=691b8f86-9efb-42d1-8927-7036c46cae7d&b=true&s=%2Fdev%2Fnvme2n1&j=auto&kd=type%3Dgp2%2Csize%3D150&c=px-cluster-aa66e19e-b848-44a6-9ea3-30b12c14383b&eks=true&stork=true&csi=true&mon=true&tel=false&st=k8s&promop=true'

- Verify if all pods are running:

      kubectl get pods -A 

    ![List all portworx pods](/images/list_px_pods.PNG)

- Verify Portworx cluster status:

      PX_POD=$(kubectl get pods -l name=portworx -n portworx -o jsonpath='{.items[0].metadata.name}')
  <!-- tsk -->
      kubectl exec -it $PX_POD -n portworx -- /opt/pwx/bin/pxctl status

    ![List all portworx pods](/images/px_cluster_status.PNG)

### [3. Portworx on Kubernetes](#use-px)
- Change working dir to demo-app/:

      cd ../demo-app

- Create a StorageClass that references Portworx as the provisioner:

      #demo-sc.yaml
      kind: StorageClass
      apiVersion: storage.k8s.io/v1
      metadata:
        name: portworx-demo-sc
      provisioner: kubernetes.io/portworx-volume
      parameters:
        repl: "1"

  <!-- tsk -->

      kubectl apply -f demo-sc.yaml

- Verify the StorageClass that we've just created: 
  
      kubectl describe sc portworx-demo-sc

    ![Portworx demo storage class describe](/images/portworx_demo_sc.PNG)

- Create a PersistentVolumeClaim referencing the portworx-demo-sc StorageClass:

      #demo-pvc.yaml
      kind: PersistentVolumeClaim
      apiVersion: v1
      metadata:
        name: portworx-demo-pvc
        annotations:
          volume.beta.kubernetes.io/storage-class: portworx-demo-sc
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 2Gi

- Verify the PVC: 

      kubectl get pvc
    ![Portworx demo PVC](/images/portworx_demo_pvc.PNG)

- Create a new deployment:

      # demo-app.yaml
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
        labels:
           app: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: k8s.gcr.io/nginx-slim:0.8
              ports:
              - containerPort: 80
              volumeMounts:
              - mountPath: /var/www/html
                name: nginx-data
            volumes:
            - name: nginx-data
              persistentVolumeClaim:
                claimName: portworx-demo-pvc
  
    <!-- tsk -->

      kubectl apply -f demo-app.yaml

- Verify the deployment:

      kubectl describe deploy nginx
    ![Portworx demo app](/images/portworx_demo_app.PNG)

### [4. Clean up resources](#cleanup)

- Tear down the EKS cluster:
  
      terraform destroy --auto-approve

- Unlink the portworx cluster:

    ![Portworx clean up](/images/portworx_cleanup.PNG)


** OPTIONAL **: 
- Edit configmap aws-auth to make EKS cluster infos visible in the UI:  
    
      kubectl edit configmap aws-auth -n kube-system
    <!-- tsk -->
      mapUsers: |
        - userarn: arn:aws:iam::[account_id]:root
          groups:
          - system:masters

## **OCI** 

[Pending] Out of capacity issue