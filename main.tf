resource "proxmox_virtual_environment_vm" "this" {
  node_name   = var.node_name
  name        = var.vm_name
  description = var.description
  tags        = var.tags
  on_boot     = var.on_boot
  started     = var.started

  # QEMU guest agent. Requires the qemu-guest-agent package running inside the
  # guest AND a power-cycle for the virtio-serial channel to attach. Defaults
  # off so this is a no-op for existing consumers.
  agent {
    enabled = var.qemu_agent_enabled
    type    = "virtio"
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.disk_storage
    import_from  = var.import_from
    size         = var.disk_size
    interface    = "scsi0"
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.vlan_id
  }

  dynamic "cdrom" {
    for_each = var.iso_file_id != null ? [1] : []
    content {
      file_id = var.iso_file_id
    }
  }

  dynamic "initialization" {
    for_each = var.cloud_init_enabled ? [1] : []
    content {
      user_data_file_id = var.cloud_init_user_data_file_id

      user_account {
        username = var.cloud_init_user
        keys     = var.cloud_init_ssh_keys
      }

      ip_config {
        ipv4 {
          address = var.cloud_init_ip
          gateway = var.cloud_init_gateway
        }
      }

      dns {
        servers = var.cloud_init_dns
      }
    }
  }

  # Cloud-init user-data and the imported base image only matter at creation
  # time (cloud-init runs once, on first boot). A re-rendered snippet or a
  # re-published upstream image must not force a destroy/recreate of a running
  # node — ignore post-create drift on those two attributes.
  lifecycle {
    ignore_changes = [
      disk[0].import_from,
      initialization[0].user_data_file_id,
    ]
  }
}
