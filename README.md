# 📖 README
This repo helps build virtual machines using packer on VMware ESXi hosts.

- [x] Build on a simple network with DHCP and DNS. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Built-in HTTP templating server.
- [x] Gracefully handle CTRL+C.

**Requirements**
- vSphere 7.0U3 ESXi host with SSH access enabled.
- A control machine with `ansible`, `hashicorp/packer` and `openssl` binaries.

**Supported VM Builds**
status | os | version | machine specs
---| --- | --- | ---
👍 | centos | 8-stream | 4 vCPU, 4 GiB vRAM, 100 GiB NVMe vDisk
👍 | debian | bullseye | 4 vCPU, 4 GiB vRAM, 100 GiB NVMe vDisk
👍 | ubuntu | focal | 4 vCPU, 6 GiB vRAM, 100 GiB NVMe vDisk
👍 | ubuntu | jammy | 4 vCPU, 6 GiB vRAM, 100 GiB NVMe vDisk

# 🌱 Getting started
1. Run the `prepare_installers.yaml` Ansible playbook.
1. Create a `installers/esx_server.pkrvars.hcl` file.  This file contains Packer variables specific to connecting to the VMware ESXi server.
1. Perform `make`, the `builder` binary will be placed at the root of the repository folder.
1. Run the `builder` binary.  Use `-h` flag to see the arguments needed.

## ⚙️ `esx_server.pkrvars.hcl`
The `installers/esx_server.pkrvars.hcl` file is used by the builder to connect to VMware ESXi host to build VMs.

```hcl2
esx_server    = "" # ESX host
esx_username      = "" # ESX user with admin and SSH access
esx_password  = "" # ESX user password
esx_network   = "" # ESX virtual network name for the VM
esx_datastore = "" # ESX datastore name to place the VM's VMDK files
```

## ⭐️ Usage
```
Usage of ./builder:
  -c string
        The path to the Packer variables file for the VMware ESX server. (default "/opt/vmware-builder/installers/esx_server.pkrvars.hcl")
  -n string
        Virtual machine name. (Required)
  -o string
        Operating system. Examples: debian, centos, ubuntu. (Required)
  -openssl-path string
        The path to the OpenSSL binary. (default "/usr/bin/openssl")
  -p string
        Virtual machine guest password. (default "password")
  -packer-path string
        The path to the Hashicorp Packer binary. (default "/usr/local/bin/packer")
  -r string
        Operating system release name. Examples: bullseye, 8-stream, focal, jammy. (Required)
  -u string
        Virtual machine guest username. (default "sysuser")
  -version
        Print program version.
```

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>
Install Packer doc | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
