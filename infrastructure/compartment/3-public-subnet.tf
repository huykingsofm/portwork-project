resource "oci_core_subnet" "vcn-public-subnet"{

  # Required
  compartment_id = oci_identity_compartment.portwork_compartment.id
  vcn_id = module.vcn.vcn_id
  cidr_block = "10.0.0.0/24"
  route_table_id = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public-security-list.id]
  display_name = "public-subnet"
}

resource "oci_core_security_list" "public-security-list"{

# Required
  compartment_id = oci_identity_compartment.portwork_compartment.id
  vcn_id = module.vcn.vcn_id

# Optional
  display_name = "security-list-for-public-subnet"
  egress_security_rules {
    stateless = false
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol = "all" 
  }
}


