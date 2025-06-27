terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.10.0"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.token
}