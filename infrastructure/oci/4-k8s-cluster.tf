resource "oci_containerengine_cluster" "portwork-cluster" {
    # Required
    compartment_id = oci_identity_compartment.portwork_compartment.id
    kubernetes_version = "v1.24.1"
    name = "portwork-cluster"
    vcn_id = module.vcn.vcn_id

    # Optional
    options {
        add_ons{
            is_kubernetes_dashboard_enabled = false
            is_tiller_enabled = false
        }
        kubernetes_network_config {
            pods_cidr = "10.244.0.0/16"
            services_cidr = "10.96.0.0/16"
        }
        #The OCIDs of the subnets used for Kubernetes services load balancers.
        service_lb_subnet_ids = [oci_core_subnet.vcn-public-subnet.id]
    }  
}