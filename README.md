# portwork-project
A portwork project

# Terraform oracle provider
- 1.Get tenancy_ocid = ""
- 2.Get user ocid = "" 
- 3.1 Generate an api signing key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two
  openssl genrsa -out private_key.pem -aes128 2048
  chmod go-rwx private_key.pem
  openssl rsa -pubout -in private_key.pem -out public_key.pem

    When you upload your public key to the identity control plane, you get a key ID in return:
    The key format is tenantId/userId/fingerprint.
    Or we can generate again: 


# Create eks cluster in aws
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

or aws configure