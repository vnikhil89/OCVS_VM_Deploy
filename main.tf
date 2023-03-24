module "OCI_vault" {
  source = ".//module//OCI_vault"
  tenancy_ocid                    = var.tenancy_ocid
  user_ocid                       = var.user_ocid
  fingerprint                     = var.fingerprint
  private_key_path                = var.private_key_path
  compartment_ocid                = var.compartment_ocid
  region                          = var.region
  vault_name                      = var.vault_name
  vm_vault_name                   = var.vm_vault_name
  
}
provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = module.OCI_vault.vcenter_passwrd[0]
  password       = module.OCI_vault.vcenter_passwrd[1]

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_host" "host" {
  name          = var.host_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Deployment of VM from template
resource "vsphere_virtual_machine" "template" {
  name             = var.vm_name
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
 

  wait_for_guest_net_timeout = 1
  wait_for_guest_ip_timeout  = 1
  num_cpus                   = 4
  memory                     = 1024 * 4
  firmware                   = "bios"
  guest_id                   = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "${var.vm_name}.vmdk"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  connection {
    type = "ssh"
	user = module.OCI_vault.vm_passwrd[0]
	password = module.OCI_vault.vm_passwrd[1]
	host = self.guest_ip_addresses[0]
  }
  provisioner "remote-exec"{
    inline=["/apche.sh"]
  }
}