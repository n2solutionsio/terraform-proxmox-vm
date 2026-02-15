variable "node_name" {
  description = "Proxmox node to create the VM on"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "description" {
  description = "Description of the virtual machine"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the VM"
  type        = list(string)
  default     = []
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2

  validation {
    condition     = var.cpu_cores > 0
    error_message = "CPU cores must be greater than 0."
  }
}

variable "cpu_type" {
  description = "CPU type (e.g., x86-64-v2-AES, host)"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048

  validation {
    condition     = var.memory >= 128
    error_message = "Memory must be at least 128 MB."
  }
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size >= 1
    error_message = "Disk size must be at least 1 GB."
  }
}

variable "disk_storage" {
  description = "Storage pool for the disk"
  type        = string
  default     = "local-lvm"
}

variable "vlan_id" {
  description = "VLAN ID for the network interface"
  type        = number
  default     = null

  validation {
    condition     = var.vlan_id == null ? true : (var.vlan_id >= 1 && var.vlan_id <= 4094)
    error_message = "VLAN ID must be between 1 and 4094."
  }
}

variable "network_bridge" {
  description = "Network bridge to attach to"
  type        = string
  default     = "vmbr0"
}

variable "iso_file_id" {
  description = "ISO file ID for CD-ROM (e.g., local:iso/ubuntu.iso)"
  type        = string
  default     = null
}

variable "cloud_init_enabled" {
  description = "Enable cloud-init configuration"
  type        = bool
  default     = false
}

variable "cloud_init_user" {
  description = "Cloud-init default user"
  type        = string
  default     = null
}

variable "cloud_init_ssh_keys" {
  description = "SSH public keys for cloud-init"
  type        = list(string)
  default     = []
  sensitive   = true
}

variable "cloud_init_ip" {
  description = "Static IP address in CIDR notation (e.g., 10.30.30.10/24), or 'dhcp'"
  type        = string
  default     = "dhcp"
}

variable "cloud_init_gateway" {
  description = "Default gateway for cloud-init networking"
  type        = string
  default     = null
}

variable "cloud_init_dns" {
  description = "DNS servers for cloud-init"
  type        = list(string)
  default     = []
}

variable "cloud_init_user_data_file_id" {
  description = "File ID for custom cloud-init user data snippet"
  type        = string
  default     = null
}

variable "on_boot" {
  description = "Start VM on host boot"
  type        = bool
  default     = true
}

variable "started" {
  description = "Whether the VM should be started after creation"
  type        = bool
  default     = true
}
