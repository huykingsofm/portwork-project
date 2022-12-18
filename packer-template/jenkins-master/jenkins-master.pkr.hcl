source "oracle-oci" "jenkins-master" {
  availability_domain = "aaaa:PHX-AD-1"
  base_image_ocid     = "ocid1.image.oc1.phx.aaaaaaaaou44ddrjagjnncmofnkqqdzqq4hgqmnyiosl655yzthflblzmvhq"
  compartment_ocid    = "ocid1.compartment.oc1..aaa"
  image_name          = "ExampleImage"
  shape               = "VM.Standard1.1"
  ssh_username        = "opc"
  subnet_ocid         = "ocid1.subnet.oc1..aaa"
}

build {
  sources = ["source.oracle-oci.jenkins-master"]
}