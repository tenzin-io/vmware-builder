# README
It stores the templates and files necessary for the installation of operating systems.

The `packer_template.pkr.hcl` is the generic Packer template and default variables for use by the virtual machine `builder` binary.  The default variables are overriden as necessary.  For instance, there are `virtual_machine.pkrvars.hcl` files that overrides specific variables pertaining to things like default CPU, memory, disk size and VMware guest OS type.

The `esx_server.pkrvars.hcl` contains the Packer variable definitions that are needed to connect to the VMware ESXi host.

The Operating System folder should be structred as follows:
- `<operating-system-name>/<operating-system-release>/virtual_machine.pkrvars.hcl` - Operating system release specific Packer variable overrides.
- `<operating-system-name>/<operating-system-release>/templates` - Every file is processed as a Go `text/template` upon request, passing in the `templateVars` struct to the template on execution.
- `<operating-system-name>/<operating-system-release>/files` - Folder to store non-template files, such as ISOs, initrd or other files needed during the pre-installation (iPXE) phase.
- `<operating-system-name>/<operating-system-release>/files/download_list.txt` - A file that contains a list of URLs that will be used to populate the files area by the `prepare_installers.yaml` Ansible playbook.