variable "tenancy_ocid" {
    default = "ocid1.tenancy.oc1..aaaaaaaak5rnadajillakj55ipehvoyvpqumxwdkptufhashwu37us22ihva"
}
variable "user_ocid" {
    default = "ocid1.user.oc1..aaaaaaaavoixckgpdsq5csyaqgtnlc7vtjkomvkhl4fgofvraidz6gfq7owq"
}
variable "fingerprint" {
    default = "f8:b6:2f:0f:11:ef:d6:4e:7e:7e:41:2a:cf:ea:ef:d9"
}

## Shoule be env
variable "private_key_path" {
    default = "~/.oci/oracle_key.pem"
}
variable "region" {
    default = "us-phoenix-1"
}

variable "compartment_name" {
    default = "portwork"
}

variable "node_pool_ssh_public_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBciBh3uykPAUysDLHtLJVI6bm1tbcAU/3TTToYL8oIaInODbO7lgkiIFEbKPhUJ/dxFFZv0mVaFKQ3KztaB5zzQzv5bVIHoDZXxCR94yNfSMxZ2B0/mJSQc+W9aPMQoMEbgTtfih7ODldzq+lMct2Y9MQVjPflsBiSRE+FsWLBSgzJlNdI1gLbBD0XgwJc5qGQ1d+mzLz1ayREDkvRrkGymRCA8NAW/VbepAFiKHQzwiRsZDQ5QlZbzDWp2FPSvoPAXFraojWYrTl6OASME+u1/eeS00T+3pbtwXfCXbZegn5sBbfWAM4iuQHoZ5GFG2sZf8sASh8aomQ8/hiBn4nolSv2AI7jskTrQu7fyI0ZE7FVOMDMJnsuC49O/Solf/hysrMu4XMH+XQ8+bv3PUf7IoEL8aNoxIhAfZwXXJbRxiZzqPnBXo6v6U1lR69LgZziDkFQYIeA4drInbYsDMF5MjWB5I9a37zrFRPpiWB51WA3UMfXZu2PlkZlCUU2b0= mc@mc"
}

variable "node_pool_node_shape_config_memory_in_gbs" {
    default = "2"
}
variable "node_pool_node_shape_config_ocpus" {
    default = "1"
}