source "vsphere-iso" "ubuntu2004" {
  CPUs                 = "${var.cpu_num}"
  RAM                  = "${var.ram}"
  boot_command         = ["<esc><esc><esc><esc>e<wait>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del><del>", "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\"<enter><wait>", "initrd /casper/initrd<enter><wait>", "boot<enter>", "<enter><f10><wait>"]
  boot_wait            = "3s"
  cluster              = "${var.vcenter_cluster}"
  convert_to_template  = true
  datastore            = "${var.vcenter_datastore}"
  disk_controller_type = ["pvscsi"]
  folder               = "${var.vcenter_folder}"
  guest_os_type        = "ubuntu64Guest"
  http_directory       = "./http"
  insecure_connection  = "true"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  network_adapters {
    network      = "${var.vm_network}"
    network_card = "vmxnet3"
  }
  shutdown_command       = "sudo shutdown -P now"
  ssh_handshake_attempts = "100"
  ssh_username           = "ubuntu"
  ssh_password           = "password"
  ssh_port               = 22
  ssh_timeout            = "20m"
  storage {
    disk_size             = "${var.disk_size}"
    disk_thin_provisioned = true
  }
  username       = vault 
  password       = "${var.vcenter_password}"
  vcenter_server = "${var.vcenter_server}"
  vm_name        = "${var.vm_name}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/from-1.5/blocks/build
build {
  sources = ["source.vsphere-iso.ubuntu2004"]
  provisioner "ansible" {
    playbook_file = "Ansible/playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=ssh-rsa'",
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
    user = "ubuntu"
  }
}
