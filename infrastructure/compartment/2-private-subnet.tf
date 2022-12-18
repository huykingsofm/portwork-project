resource "oci_core_subnet" "vcn-private-subnet"{

  # Required
  compartment_id = oci_identity_compartment.portwork_compartment.id
  vcn_id = module.vcn.vcn_id
  cidr_block = "10.0.1.0/24"
  route_table_id = module.vcn.nat_route_id
  security_list_ids = [oci_core_security_list.private-security-list.id]
  display_name = "private-subnet"
  depends_on = [
    module.vcn
  ]
}

resource "oci_core_security_list" "private-security-list"{

# Required
  compartment_id = oci_identity_compartment.portwork_compartment.id
  vcn_id = module.vcn.vcn_id

# Optional
  display_name = "security-list-for-private-subnet"
  egress_security_rules {
    stateless = false
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol = "all" 
  }
  #SSh rule from public subnet
  ingress_security_rules { 
    stateless = false
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol = "6"
    tcp_options { 
        min = 22
        max = 22
    }
  }
  #Ping from internet
  ingress_security_rules { 
    stateless = false
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol = "1"
    icmp_options {
      type = 3
      code = 4
    } 
  }
  ingress_security_rules { 
    stateless = false
    source = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1  
    protocol = "1"

    # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    icmp_options {
      type = 3 # Destination unreachable
    } 
  }
}


