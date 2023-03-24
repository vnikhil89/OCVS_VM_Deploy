output "VM-IP"{
  value = vsphere_virtual_machine.template.guest_ip_addresses[0]
 }