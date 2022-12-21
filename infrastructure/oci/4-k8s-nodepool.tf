resource "oci_containerengine_node_pool" "portwork-nodepool" {
    # Required
    cluster_id = oci_containerengine_cluster.portwork-cluster.id
    compartment_id = oci_identity_compartment.portwork_compartment.id
    kubernetes_version = "v1.24.1"
    name = "portwork-nodepool"
    node_config_details{
        placement_configs{
            availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
            subnet_id = oci_core_subnet.vcn-private-subnet.id
        } 
        # placement_configs{
        #     availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
        #     subnet_id = oci_core_subnet.vcn-private-subnet.id
        # }
        # placement_configs{
        #     availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
        #     subnet_id = oci_core_subnet.vcn-private-subnet.id
        # }
        size = 1
    }
    node_shape = "VM.Standard.E3.Flex"
    node_shape_config {

        #Optional
        memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
        ocpus = var.node_pool_node_shape_config_ocpus
    }
    # Using image Oracle-Linux-8.x
    # Find image OCID for your region from https://docs.oracle.com/iaas/images/ 
    node_source_details {
         image_id = "ocid1.image.oc1.phx.aaaaaaaajnmlrissxtk5ssava7b7wsbhr27bfs2e4jr7we4vlzvkm6oc45nq"
         source_type = "image"
    }
 
    # Optional
    initial_node_labels {
        key = "name"
        value = "portwork-cluster"
    }   
    ssh_public_key = var.node_pool_ssh_public_key 
}