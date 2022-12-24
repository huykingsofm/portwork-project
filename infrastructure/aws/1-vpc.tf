module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "education-vpc"

  cidr = "10.1.0.0/16"
  azs  = ["us-west-2a", "us-west-2b", "us-west-2c"]

  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

data "aws_availability_zones" "azs" {
  all_availability_zones = true
}


#Value (us-west-2-las-1a) for parameter availabilityZone is invalid.
#Subnets can currently only be created in the following availability zones: us-west-2a, us-west-2b, us-west-2c, us-west-2d.