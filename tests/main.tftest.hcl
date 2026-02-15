mock_provider "proxmox" {}

variables {
  node_name      = "proxmox-01"
  vm_name        = "test-vm"
  cpu_cores      = 4
  memory         = 8192
  disk_size      = 50
  vlan_id        = 30
  network_bridge = "vmbr1"
}

run "vm_name_and_node" {
  command = plan

  assert {
    condition     = proxmox_virtual_environment_vm.this.name == "test-vm"
    error_message = "VM name should be test-vm"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.node_name == "proxmox-01"
    error_message = "VM should be on proxmox-01"
  }
}

run "cpu_and_memory" {
  command = plan

  assert {
    condition     = proxmox_virtual_environment_vm.this.cpu[0].cores == 4
    error_message = "CPU cores should be 4"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.memory[0].dedicated == 8192
    error_message = "Memory should be 8192 MB"
  }
}

run "vlan_and_bridge" {
  command = plan

  assert {
    condition     = proxmox_virtual_environment_vm.this.network_device[0].bridge == "vmbr1"
    error_message = "Network bridge should be vmbr1"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.network_device[0].vlan_id == 30
    error_message = "VLAN ID should be 30"
  }
}

run "iso_attachment" {
  command = plan

  variables {
    iso_file_id = "local:iso/ubuntu-24.04.iso"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.cdrom[0].file_id == "local:iso/ubuntu-24.04.iso"
    error_message = "ISO should be attached"
  }
}

run "defaults" {
  command = plan

  variables {
    node_name = "proxmox-01"
    vm_name   = "default-vm"
    cpu_cores = 2
    memory    = 2048
    disk_size = 20
    vlan_id   = null
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.cpu[0].cores == 2
    error_message = "Default CPU cores should be 2"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.memory[0].dedicated == 2048
    error_message = "Default memory should be 2048 MB"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.on_boot == true
    error_message = "Default on_boot should be true"
  }
}

run "cloud_init_config" {
  command = plan

  variables {
    node_name           = "proxmox-01"
    vm_name             = "cloud-vm"
    cloud_init_enabled  = true
    cloud_init_user     = "ubuntu"
    cloud_init_ssh_keys = ["ssh-ed25519 AAAA... test@example"]
    cloud_init_ip       = "10.30.30.10/24"
    cloud_init_gateway  = "10.30.30.1"
    cloud_init_dns      = ["1.1.1.1", "8.8.8.8"]
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.initialization[0].user_account[0].username == "ubuntu"
    error_message = "Cloud-init user should be ubuntu"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.initialization[0].ip_config[0].ipv4[0].address == "10.30.30.10/24"
    error_message = "Cloud-init IP should be set"
  }
}
