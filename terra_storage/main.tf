#key
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.user_id
  description        = "static access key for object storage"
  provisioner "local-exec" {
    command = "echo $secret_key > ../terra_cluster/secret.terraform.tfvars"
    environment = {
      secret_key = "secret_key = \"${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}\""
    }
  }
}


resource "yandex_kms_symmetric_key" "key-os" {
  name                = var.key_name
  description         = "encrypt object storage"
  default_algorithm   = "AES_128"
  rotation_period     = "8760h"
}
#storage
resource "yandex_storage_bucket" "sb" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.storage_name
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-os.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  provisioner "local-exec" {
    command = "echo $access_key >> ../terra_cluster/secret.terraform.tfvars"
    environment = {
      access_key = "access_key = \"${yandex_iam_service_account_static_access_key.sa-static-key.access_key}\""
    }
  }
}

