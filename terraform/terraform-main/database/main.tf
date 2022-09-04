resource "random_uuid" "resource_group_name" {
}

module "resource_naming" {
  source = "../../terraform-modules/random"
  length = 7
}

module "administrator_login" {
  source = "../../terraform-modules/random"
  length = 11
}

module "administrator_login_password" {
  source  = "../../terraform-modules/random"
  length  = 23
  upper   = true
  special = true
  numeric = true
}

resource "azurerm_resource_group" "rg" {
  name     = "${random_uuid.resource_group_name.result}-rg"
  location = "Central US"
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = module.resource_naming.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "mysqladminun" # module.administrator_login.result
  administrator_login_password = "H@Sh1CoR3!"   # module.administrator_login_password.result

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = module.resource_naming.result
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
