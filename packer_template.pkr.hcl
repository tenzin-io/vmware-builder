packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

variable "vm_datastore" {
  type        = string
  description = "The folder path to place virtual machine files."
}

#
# Virtual machine variables
#
variable "vm_name" {
  type        = string
  description = "The virtual machine name."
}

variable "vm_cpus" {
  default     = 4
  description = "The virtual machine vCPU count."
}

variable "vm_memory" {
  default     = 4096
  description = "The virtual machine memory size in MiB."
}

variable "vm_disk_size" {
  default     = 20480
  description = "The virtual machine disk size in MiB."
}

variable "vm_guest_os_type" {
  default     = "arm-debian12-64"
  description = "The virtual machine guest OS type."
}

variable "ssh_public_key" {
  type        = string
  default     = ""
  description = "The SSH public key to add to virtual machine user's authorized_keys file."
}

variable "vm_username" {
  default     = "root"
  description = "The virtual machine user name."
}

variable "vm_password" {
  default     = "password"
  sensitive   = true
  description = "The virtual machine user password."
}

variable "vm_user_id" {
  default     = "10001"
  description = "The virtual machine user's user id."
}

variable "vm_connection_type" {
  default     = "nat"
  description = "The type of network connection between the host and virtual machine. Example: nat, bridged"
}

source "vmware-iso" "virtual_machine" {
  boot_command = [
    templatefile("${path.root}/docs/debian/bookworm/boot_command.tpl", { vm_name = var.vm_name })
  ]
  vm_name       = var.vm_name
  cpus          = var.vm_cpus
  memory        = var.vm_memory
  disk_size     = var.vm_disk_size
  guest_os_type = var.vm_guest_os_type
  version       = "21" # see https://kb.vmware.com/s/article/1003746
  http_content = {
    "/preseed.cfg" = templatefile("${path.root}/docs/debian/bookworm/preseed.cfg", {
      vm_name     = var.vm_name,
      vm_password = var.vm_password
    })
  }
  iso_url              = "https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-12.5.0-arm64-netinst.iso"
  iso_checksum         = "sha256:1090f86eaf21dd305bb7ec24629f8421218d8cff02e93a1a87554153ab4efa38"
  disk_adapter_type    = "nvme"
  network_adapter_type = "e1000e"
  keep_registered      = true
  output_directory     = "${var.vm_datastore}/${var.vm_name}"
  skip_compaction      = true
  skip_export          = true
  ssh_username         = var.vm_username
  ssh_password         = var.vm_password
  ssh_timeout          = "25m"
  shutdown_command     = "poweroff"
  headless             = true
  snapshot_name        = "clean"
  usb                  = true # console keyboard functionality
  vmx_data = {
    "architecture"     = "arm64"
    "usb_xhci.present" = true # console keyboard functionality
  }
  vmx_data_post = {
    "ethernet0.connectionType" = var.vm_connection_type
  }
}

build {
  sources = ["source.vmware-iso.virtual_machine"]

  provisioner "shell" {
    inline = [
      "test -d ~/.ssh || mkdir -m 0700 ~/.ssh",
      "touch ~/.ssh/authorized_keys",
      "chmod 0600 ~/.ssh/authorized_keys",
      "echo '${var.ssh_public_key}' > ~/.ssh/authorized_keys"
    ]
  }
}
