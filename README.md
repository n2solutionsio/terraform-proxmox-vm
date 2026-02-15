# terraform-proxmox-vm

OpenTofu module for provisioning a single Proxmox VM with cloud-init, VLAN, and ISO support.

## Usage

```hcl
module "vm" {
  source = "git::https://github.com/n2solutionsio/terraform-proxmox-vm.git?ref=v0.1.0"

  node_name      = "proxmox-01"
  vm_name        = "my-vm"
  cpu_cores      = 4
  memory         = 8192
  disk_size      = 50
  vlan_id        = 30
  network_bridge = "vmbr1"

  cloud_init_enabled = true
  cloud_init_user    = "ubuntu"
  cloud_init_ip      = "10.30.30.10/24"
  cloud_init_gateway = "10.30.30.1"
}
```

## Requirements

| Name | Version |
|------|---------|
| OpenTofu/Terraform | >= 1.6.0 |
| proxmox | ~> 0.95.0 |

## License

MPL-2.0
