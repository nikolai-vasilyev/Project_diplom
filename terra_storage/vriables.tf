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
variable "user_id" {
  type        = string
  sensitive   = true
  description = "VARIABLE USER ID terra_account"
}
variable "secret_key" {
  type        = string
  sensitive   = true
  description = "VARIABLE secret key terra_account"
}
variable "access_key" {
  type        = string
  sensitive   = true
  description = "VARIABLE access key terra_account"
}
##key vars
variable "key_name" {
  type        = string
  default     = "key"
  description = "key name infrastructure"
}

variable "storage_name" {
  type        = string
  default     = "backend-terra"
  description = "storage name infrastructure"
}
