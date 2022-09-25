resource "random_uuid" "resource_group_name" {
}

module "resource_naming" {
  source = "../terraform-modules/random"
  length = 7
}

resource "azurerm_resource_group" "rg" {
  name     = random_uuid.resource_group_name.result
  location = "Central US"
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = module.resource_naming.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

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

resource "azurerm_container_registry" "acr" {
  name                = "${module.resource_naming.result}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Create the Linux App Service Plan
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan
#This resource has been deprecated in version 3.0 of the AzureRM provider and will be removed in version 4.0. Please use azurerm_service_plan resource instead.

resource "azurerm_service_plan" "appserviceplan" {
  name                = "asp-${module.resource_naming.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# #Create the web app, pass in the App Service Plan ID
# #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service
# #This resource has been deprecated in version 3.0 of the AzureRM provider and will be removed in version 4.0. Please use azurerm_linux_web_app and azurerm_windows_web_app resources instead.
resource "azurerm_linux_web_app" "api" {
  name                = "api-${module.resource_naming.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    always_on = false
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/api"
      docker_image_tag = "latest"
      node_version     = "16-lts"
    }
  }
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password

  }
}

output "acr_server" {
  value = azurerm_container_registry.acr.login_server
}
output "acr_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "administrator_login" {
  value = azurerm_mysql_server.mysql_server.administrator_login
}

output "administrator_login_password" {
  value     = azurerm_mysql_server.mysql_server.administrator_login_password
  sensitive = true
}

output "mysql_database" {
  value = azurerm_mysql_database.mysql_database.name
}

output "mysql_host" {
  value = "${azurerm_mysql_database.mysql_database.name}.mysql.database.azure.com"
}
