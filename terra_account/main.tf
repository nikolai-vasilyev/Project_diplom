# account
resource "yandex_iam_service_account" "sa" {  
    name = var.account_name
    description = "manage cluster, storage, key"  
    folder_id = var.folder_id
    provisioner "local-exec" {
      command = "echo $user_id > ../terra_storage/terraform.tfvars"
      environment = {
        user_id = "user_id = \"${yandex_iam_service_account.sa.id}\""
      }
    }
} 
 

# roles
resource "yandex_resourcemanager_folder_iam_binding" "compute_admin" {
  folder_id   = var.folder_id
  role      = "compute.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc_admin" {
  folder_id   = var.folder_id
  role      = "vpc.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "storage_admin" {
  folder_id   = var.folder_id
  role      = "storage.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "admin_keys" {
  folder_id   = var.folder_id
  role      = "kms.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.sa.id}"
  ]
}
