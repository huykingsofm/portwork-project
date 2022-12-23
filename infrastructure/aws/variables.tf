// Provided at runtime

# variable "region" {
#   type = string
#   description = "AWS region"
# }

# variable "shared_credentials_file" {
#   type = string
#   description = "AWS credentials file path"
# }

# variable "aws_profile" {
#   type = string
#   description = "AWS profile"
# }

# variable "author" {
#   type = string
#   description = "Created by"
# }

# variable "availability_zones" {
#   type        = list
#   description = "List of Availability Zones"
# }

// Default values

variable "vpc_name" {
  type = string
  description = "VPC name"
  default     = "sandbox"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "cluster_name" {
  type = string
  description = "EKS cluster name"
  default     = "portwork"
}

variable "public_subnets_count" {
  type = number
  description = "Number of public subnets"
  default = 3
}

variable "private_subnets_count" {
  type = number
  description = "Number of private subnets"
  default = 3
}

variable "ssh_public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBciBh3uykPAUysDLHtLJVI6bm1tbcAU/3TTToYL8oIaInODbO7lgkiIFEbKPhUJ/dxFFZv0mVaFKQ3KztaB5zzQzv5bVIHoDZXxCR94yNfSMxZ2B0/mJSQc+W9aPMQoMEbgTtfih7ODldzq+lMct2Y9MQVjPflsBiSRE+FsWLBSgzJlNdI1gLbBD0XgwJc5qGQ1d+mzLz1ayREDkvRrkGymRCA8NAW/VbepAFiKHQzwiRsZDQ5QlZbzDWp2FPSvoPAXFraojWYrTl6OASME+u1/eeS00T+3pbtwXfCXbZegn5sBbfWAM4iuQHoZ5GFG2sZf8sASh8aomQ8/hiBn4nolSv2AI7jskTrQu7fyI0ZE7FVOMDMJnsuC49O/Solf/hysrMu4XMH+XQ8+bv3PUf7IoEL8aNoxIhAfZwXXJbRxiZzqPnBXo6v6U1lR69LgZziDkFQYIeA4drInbYsDMF5MjWB5I9a37zrFRPpiWB51WA3UMfXZu2PlkZlCUU2b0= mc@mc"
}