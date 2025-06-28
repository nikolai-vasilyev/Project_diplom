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

#key
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

#####################################################Write tfwars storage
resource "null_resource" "write-secret-key" {
  provisioner "local-exec" {
    command = "echo $secret_key >> ../terra_storage/terraform.tfvars"
    environment = {
      secret_key = "secret_key = \"${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}\""
    }
  }
  depends_on = [yandex_iam_service_account_static_access_key.sa-static-key]
}
resource "null_resource" "write-access-key" {
  provisioner "local-exec" {
    command = "echo $access_key >> ../terra_storage/terraform.tfvars"
    environment = {
      access_key = "access_key = \"${yandex_iam_service_account_static_access_key.sa-static-key.access_key}\""
    }
  }
  depends_on = [null_resource.write-secret-key]
}
################################write in cluster
resource "null_resource" "write-secret-key-cluster" {
  provisioner "local-exec" {
    command = "echo $secret_key > ../terra_cluster/secret.terraform.tfvars"
    environment = {
      secret_key = "secret_key = \"${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}\""
    }
  }
  depends_on = [null_resource.write-access-key]
}
resource "null_resource" "write-access-key-cluster" {
  provisioner "local-exec" {
    command = "echo $access_key >> ../terra_cluster/secret.terraform.tfvars"
    environment = {
      access_key = "access_key = \"${yandex_iam_service_account_static_access_key.sa-static-key.access_key}\""
    }
  }
  depends_on = [null_resource.write-secret-key-cluster]
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

resource "yandex_resourcemanager_folder_iam_binding" "alb_admin" {
  folder_id   = var.folder_id
  role      = "load-balancer.admin"
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
