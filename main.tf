provider "azurerm" {
  features {}
}

# Resource Group creation
resource "azurerm_resource_group" "rg" {
  name     = "Nebula1"
  location = "Central India" # Fixed typo: 'Ceentral' to 'Central'
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "cinuatwhereismyworldweb"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "whereismyworld"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Azure Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "CIN-UAT-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    application_stack {
      # Use these for Tomcat environments
      java_version = "17"
      java_server = "TOMCAT"
      java_server_version     = "9.0"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
  }
}

# Blue-Green Deployment Slot
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    application_stack {
      java_version = "17"
      java_server = "TOMCAT"
      java_server_version = "9.0"
    }
  }
}

resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false # Lowercase usually safer for DNS-based names
}
