provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
data "oci_vault_secrets" "vcenter_secrets" {
    compartment_id = var.compartment_ocid
    name = var.vault_name
}
data "oci_vault_secrets" "vm_secrets" {
    compartment_id = var.compartment_ocid
    name = var.vm_vault_name
}

data "oci_secrets_secretbundle" "vcenter_bundle" {
    secret_id = data.oci_vault_secrets.vcenter_secrets.secrets[0].id
}
data "oci_secrets_secretbundle" "vm_bundle" {
    secret_id = data.oci_vault_secrets.vm_secrets.secrets[0].id
}
output "vcenter_passwrd" {
    value = split("/",base64decode(data.oci_secrets_secretbundle.vcenter_bundle.secret_bundle_content[0].content))
}
output "vm_passwrd" {
    value = split("/",base64decode(data.oci_secrets_secretbundle.vm_bundle.secret_bundle_content[0].content))
}