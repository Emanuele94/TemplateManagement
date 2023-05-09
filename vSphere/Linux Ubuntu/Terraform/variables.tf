variable "vsphere_server" {
    description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
    default = "vcd02vc01.arubaeng.lab"
}

variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: vsphereuser"
    default = "administrator@vsphere.local"
}

variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "Arub4Tech22!"
}

variable "virtual_machine_dns_servers" {
  type    = list
  default = ["10.154.8.10", "10.154.8.11"]
}