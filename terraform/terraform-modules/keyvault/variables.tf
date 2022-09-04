variable "keyvault_name" {
  description = "Key Vault name"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "enabled_for_disk_encryption" {
  type = bool
}

variable "tenant_id" {
  type = string
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "purge_protection_enabled" {
  type = bool
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "object_id" {
  type = string
}

variable "key_permissions" {
  type = list(string)
}

variable "secret_permissions" {
  type = list(string)
}

variable "network_acls_bypass" {
  type    = string
  default = "AzureServices"
}

variable "network_acls_default_action" {
  type    = string
  default = "Deny"
}
