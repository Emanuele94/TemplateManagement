provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
 name = "IT2-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "CELL02_DATASTORE01"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "CELL02"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "CELL2_VMK-NETWORK"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "win2019_template_packer"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "win2019tf"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  num_cpus         = 4
  memory           = 2048
  guest_id         = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.template.scsi_type}"
  firmware         = "${var.vsphere_vm_firmware}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    unit_number      = 0
    thin_provisioned = true
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
  }

  clone {
   template_uuid = "${data.vsphere_virtual_machine.template.id}"
   customize {
     windows_options {
       computer_name = "win2019tf"
       admin_password  = "secretpassword"
       auto_logon      = true
       # time_zone   = var.time_zone - usecode: https://learn.microsoft.com/en-us/previous-versions/windows/embedded/ms912391(v=winembedded.11)?redirectedfrom=MSDN
       # product_key  = var.productkey
       # https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine - search for "Windows Customization Options"
   }
  
   network_interface { 
     ipv4_address = "10.154.9.126"
     ipv4_netmask = 26 
     dns_server_list = var.virtual_machine_dns_servers
     dns_domain      = "test.lab"
   }
  
   ipv4_gateway = "10.154.9.65"
  }

}
}
