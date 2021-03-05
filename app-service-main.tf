##############################
## Azure App Service - Main ##
##############################

# Create a Resource Group
data "azurerm_resource_group" "appservice-rg" {
  name     = "myapp-${var.region}-${var.environment}-${var.app_name}-app-service-rg"

  tags = {
    description = var.description
    environment = var.environment
    owner       = var.owner  
  }
}

# Create the App Service Plan
resource "azurerm_app_service_plan" "service-plan" {
  name                = "myapp-${var.region}-${var.environment}-${var.app_name}-service-plan"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.appservice-rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    description = var.description
    environment = var.environment
    owner       = var.owner  
  }
}

# Create the App Service
resource "azurerm_app_service" "app-service" {
  name                = "myapp-${var.region}-${var.environment}-${var.app_name}-app-service"
  location            = azurerm_resource_group.appservice-rg.location
  resource_group_name = data.azurerm_resource_group.appservice-rg.name
  app_service_plan_id = azurerm_app_service_plan.service-plan.id

  site_config {
    linux_fx_version = "DOTNETCORE|3.1"
  }

  tags = {
    description = var.description
    environment = var.environment
    owner       = var.owner  
  }
}
