resource "oci_identity_compartment" "portwork_compartment" {
    #Parent id
    compartment_id = var.tenancy_ocid
    description = "Compartment for tf resources"
    name = var.compartment_name
}