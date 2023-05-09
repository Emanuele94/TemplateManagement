variable "vsphere_server" {
    description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
    default = "vc.test.lab"
}

variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: vsphereuser"
    default = "administrator@vsphere.local"
}

variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "testest"
}

variable "virtual_machine_dns_servers" {
  type    = list
  default = ["10.154.8.10", "10.154.8.11"]
}

variable "vsphere_vm_firmware" {
  description = "Firmware set to bios or efi depending on Template"
  default = "efi"
}
