resource "proxmox_virtual_environment_vm" "this" {
  node_name   = var.node_name
  name        = var.vm_name
  description = var.description
  tags        = var.tags
  on_boot     = var.on_boot
  started     = var.started

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

  # Cloud-init and the imported base image only matter at creation time
  # (cloud-init runs once, on first boot). Ignore ALL post-create drift on the
  # initialization block and the imported disk so a running node is never
  # rebuilt or errored for boot-time-only changes:
  #  - user_data_file_id: re-rendered snippets shouldn't force replacement
  #  - user_account.keys: write-only in the provider, so it perma-diffs; worse,
  #    applying it rewrites the ide2 cloud-init drive, which Proxmox rejects on
  #    a running VM ("hotplug problem - unable to change media type")
  #  - import_from: a re-published upstream image shouldn't touch a built disk
  lifecycle {
    ignore_changes = [
      disk[0].import_from,
      initialization,
    ]
  }
}
