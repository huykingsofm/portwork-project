module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.5.3"
  # insert the 1 required variable here

  compartment_id =  oci_identity_compartment.portwork_compartment.id
  region = var.region

  create_internet_gateway = true
  create_nat_gateway = true
  create_service_gateway = true

  vcn_cidrs = ["10.0.0.0/16"]
  vcn_name = "vcn-portwork"
}