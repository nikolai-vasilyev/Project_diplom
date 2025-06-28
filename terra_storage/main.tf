resource "yandex_kms_symmetric_key" "key-os" {
  name                = var.key_name
  description         = "encrypt object storage"
  default_algorithm   = "AES_128"
  rotation_period     = "8760h"
}
#storage
resource "yandex_storage_bucket" "sb" {
  access_key            = var.access_key
  secret_key            = var.secret_key
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
    command = "echo $bucket >> ../terra_cluster/secret.terraform.tfvars"
    environment = {
      bucket = "bucket    = \"${yandex_storage_bucket.sb.bucket}\""
    }
  }
}
