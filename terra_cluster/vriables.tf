#cloud vars
variable "cloud_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "token" {
  type        = string
  sensitive   = true
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
variable "folder_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

##names
locals {
  network = "cluster"
  z1 = "zone1"
  z2 = "zone2"
  z3 = "zone3"
  zone1_name = "${local.network}-${local.z1}"
  zone2_name = "${local.network}-${local.z2}"
  zone3_name = "${local.network}-${local.z3}"
  control_name = "${local.network}-${local.z1}-control"
  work-b_name = "${local.network}-${local.z2}-work_b"
  work-d_name = "${local.network}-${local.z3}-work_d"
  ssh-keys = file("~/.ssh/id_ed25519.pub")
}

variable "key_name" {
  type        = string
  default     = "key"
  description = "key name"
}

variable "route_name" {
  type        = string
  default     = "route_cluster"
  description = "table name cluster"
}

##resources
variable "resource_nodes" {
  type = map(map(number))
  default = {
    control = {
      count = 1
      cores = 2
      memory = 4
      core_fraction = 5
    }
    work-b = {
      count = 1
      cores = 2
      memory = 2
      core_fraction = 5
    }
    work-d = {
      count = 1
      cores = 2
      memory = 2
      core_fraction = 5
    }
  }
}
variable "vm_image" {
  type        = string
  default     = "fd8o5ddn529a6s8aldav"
  description = "image_id"
}

###control
variable "control_platform" {
  type        = string
  default     = "standard-v2"
  description = "platform version"
}
variable "preemptible_control" {
  type        = bool
  default     = true
  description = "preemptible on"
}

###work
variable "work_platform" {
  type        = string
  default     = "standard-v2"
  description = "platform version"
}
variable "preemptible_work" {
  type        = bool
  default     = true
  description = "preemptible on"
}

##network
variable "zones" {
  type = map
  default = {
      zone1 = "ru-central1-a"
      zone2 = "ru-central1-b"
      zone3 = "ru-central1-d"
  }
}
variable "zones_cidr" {
  type = map
  default = {
    zone1 = ["192.168.10.0/24"]
    zone2 = ["192.168.20.0/24"]
    zone3 = ["192.168.30.0/24"]
  }
}
