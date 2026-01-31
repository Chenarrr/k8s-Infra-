variable "cpus" {
  description = "Number of CPUs for each node"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of RAM for each node (e.g., 2G)"
  type        = string
  default     = "2G"
}

variable "disk" {
  description = "Disk size for each node (e.g., 20G)"
  type        = string
  default     = "20G"
}

variable "image" {
  description = "Image to use for the VMs"
  type        = string
  default     = "ubuntu-lts"
}
