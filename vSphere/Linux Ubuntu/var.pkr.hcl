variable "vcenter_username" {
    description = "vCenter username."
    type    = string
}
 
variable "vcenter_password" {
    description = "vCenter password."
    type    = string
    sensitive = true
}
 
variable "vcenter_server" {
    description = "vCenter server to connect."
    type    = string
}
 
variable "vcenter_cluster" {
    description = "Which cluster to select from the vCenter."
    type    = string
}

#variable "vcenter_datacenter" {
#    description = "Which datacentre to select from the vCenter cluster."
#    type    = string
#}
 
variable "vcenter_host" {
    description = "Which ESXi host to select from the vCenter datacentre."
    type    = string
}
 
variable "vcenter_datastore" {
    description = "Which datastore to select from the ESXI host."
    type    = string
}
 
variable "vcenter_folder" {
    description = "The vCenter folder to store the template"
    type    = string
}
 
variable "vm_version" {
    description = "Defaults to most current VM hardware supported by vCenter."
    type = number
}
 
variable "vm_name" {
    description = "Name of the VM you are going to be templating."
    type = string
}
 
variable "vm_guest_os_type" {
    description = "Defaults to guest os type of otherGuest."
    type = string
}
 
variable "network_card" {
    description = "Defaults network card type."
    type = string
    default = "vmxnet3"
}

variable "vm_network" {
    description = "VM network "
    type = string
}

variable "vm_firmware"{
    description = "Packer by default uses BIOS."
    type = string
    default = "efi"
}
 
variable "cpu_num" {
    description = "Number of CPU cores."
    type = number
    default = 2
}
 
variable "ram" {
    description = "Amount of RAM in MB."
    type = number
    default = 4096
}
 
variable "disk_size" {
    description = "The size of the disk in MB."
    type = number
    default = 40960
}
 
variable "iso_url" {
    description = "ISO for OS unattendeded installs."
    type = string
}

variable "iso_checksum" {
    description = "Checksum for ISO"
    type = string
}
