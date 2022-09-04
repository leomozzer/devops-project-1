output "key_vault_id" {
  value = {
    "key" : "key_vault_id"
    "output" : azurerm_key_vault.keyvault.id
  }
}
