packer {
  required_version = ">= 1.7.4"
 
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
      # Github Plugin Repo https://github.com/rgl/packer-plugin-windows-update
    }
  }
}
 
source "vsphere-iso" "windows_sysprep" {
  insecure_connection     = true
 
  vcenter_server          = var.vcenter_server
  username                = var.vcenter_username
  password                = var.vcenter_password
  cluster                 = var.vcenter_cluster
# datacenter              = var.vcenter_datacenter
  host                    = var.vcenter_host
  datastore               = var.vcenter_datastore
  folder                  = var.vcenter_folder
 
  convert_to_template     = true
  notes                   = "Build date: ${formatdate ("YYYYMMDD_hhmm", timestamp())}\n This template is sysprepd and can be used for domain deployments."
 
  ip_wait_timeout         = "20m"
  ip_settle_timeout       = "1m"
  communicator            = "winrm"
  #winrm_port             = "5985"
 
  winrm_timeout           = "1h"
  winrm_use_ssl           = false
  winrm_port              = 5985
  #winrm_insecure          = true
 
  pause_before_connecting = "5m"
  winrm_username          = var.os_username
  winrm_password          = var.os_password
 
  vm_name                 = "${var.vm_name}"
#  vm_name                 = "${var.vm_name}_${formatdate ("hhmm", timestamp())}"
#  vm_name                 = "${var.vm_name}_${formatdate ("YYYYMMDD_hhmm", timestamp())}"
 
  vm_version              = var.vm_version
  firmware                = var.vm_firmware
  guest_os_type           = var.vm_guest_os_type
  CPUs                    = var.cpu_num
  CPU_hot_plug            = true
  RAM                     = var.ram
  RAM_reserve_all         = false
  RAM_hot_plug            = true
  video_ram               = "16384"
  cdrom_type              = "sata"
  remove_cdrom            = false
  disk_controller_type    = ["lsilogic-sas"]
 
  network_adapters {
    network               = var.vm_network
    network_card          = var.network_card
  }
 
   storage {
    disk_thin_provisioned = true
    disk_size             = var.disk_size
  }
 
  iso_url                 = var.iso_url
  iso_checksum            = var.iso_checksum
  iso_paths = [
    "[] /usr/lib/vmware/isoimages/windows.iso"
  ]
  
  #floppy_dirs = ["scripts",]
  #floppy_files = ["unattended/autounattend.xml"]
  cd_files = ["scripts/unattended/autounattend.xml", "scripts/vmwaretools.cmd", "scripts/setup.ps1"]
  cd_label = "bootstrap"
  
  boot_wait    = "3s"
  boot_command = [
    "<spacebar><spacebar>"
  ]
}

build {
  /*
  Note that provisioner "Windows-Update" performs Windows updates and reboots where necessary.
  Run the update provisioner as many times as you need. I found that 3-to-4 runs tended,
  to be enough to install all available Windows updates. Do check yourself though!
  */
 
  sources = ["source.vsphere-iso.windows_sysprep"]
 
#provisioner "powershell" {
#  pause_before      = "2m"
#  scripts          = ["scripts/vmware-tools.ps1"]
#}
 
provisioner "powershell" {
  pause_before      = "2m"
  scripts          = ["scripts/setup.ps1"]
}
 
 
  provisioner "windows-restart" { # A restart to settle Windows prior to updates
    pause_before    = "2m"
    restart_timeout = "15m"
  }
 
 
  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
#      "exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
#      "exclude:$_.Title -like '*Preview*'",
      "include:$_.Title -like '*Security*'",
      "include:$_.Title -like '*KB5012170*'",
    ]
  }
 
  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      "include:$_.Title -like '*Security*'",
      "include:$_.Title -like '*KB5019181*'"    
    ]
  }
 
  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      "include:$_.Title -like '*Security*'",
      "include:$_.Title -like '*KB5019181*'"
    ]
  }
 
  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      "include:$_.Title -like '*Security*'",
      "include:$_.Title -like '*KB5019181*'"
    ]
  }
 
 
  provisioner "powershell" {
    pause_before      = "2m"
    elevated_user     = var.os_username
    elevated_password = var.os_password
    script            = "scripts/cleanup.ps1"
    timeout           = "15m"
  }
 
#  provisioner "powershell" {
#    pause_before      = "2m"
#    elevated_user     = var.os_username
#    elevated_password = var.os_password_workstation
#    script            = "scripts/customise_win_10.ps1"
#    timeout           = "15m"
#  }
 
#  provisioner "powershell" {
#    pause_before      = "2m"
#    elevated_user     = var.os_username
#    elevated_password = var.os_password
#    script            = "scripts/customise.ps1"
#    timeout           = "15m"
#  }
 
#__MS_SQL_SERVER__  provisioner "powershell" {
#__MS_SQL_SERVER__    pause_before      = "2m"
#__MS_SQL_SERVER__    elevated_user     = var.os_username
#__MS_SQL_SERVER__    elevated_password = var.os_password_workstation
#__MS_SQL_SERVER__    script            = "scripts/install_sqlserver.ps1"
#__MS_SQL_SERVER__    timeout           = "45m"
#__MS_SQL_SERVER__  }
 
#__MS_SQL_SERVER__  provisioner "powershell" {
#__MS_SQL_SERVER__    pause_before      = "2m"
#__MS_SQL_SERVER__    elevated_user     = var.os_username
#__MS_SQL_SERVER__    elevated_password = var.os_password_workstation
#__MS_SQL_SERVER__    script            = "scripts/install_sqlssms.ps1"
#__MS_SQL_SERVER__    timeout           = "45m"
#__MS_SQL_SERVER__  }
 
  provisioner "windows-restart" { # A restart before sysprep to settle the VM once more.
    pause_before    = "2m"
    restart_timeout = "1h"
  }
 
#  provisioner "powershell" {
#    pause_before      = "2m"
#    elevated_user     = var.os_username
#    elevated_password = var.os_password_workstation
#    script            = "scripts/localadmin.ps1"
#    timeout           = "15m"
#  }
 
 
#  provisioner "powershell" {
#    pause_before      = "2m"
#    elevated_user     = var.os_username
#    elevated_password = var.os_password_workstation
#    script            = "scripts/sysprep_win_10.ps1"
#    timeout           = "15m"
#  }
 
#provisioner "powershell" {
#    pause_before      = "2m"
#    elevated_user     = var.os_username
#    elevated_password = var.os_password_workstation
#    script            = "scripts/install_virtio-3.ps1"
#   timeout           = "15m"
#}
}
