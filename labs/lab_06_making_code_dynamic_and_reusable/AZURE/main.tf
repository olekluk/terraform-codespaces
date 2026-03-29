# Get information about the current client configuration
data "azurerm_client_config" "current" {}

# Get information about the current subscription
data "azurerm_subscription" "current" {}

locals {
  tags = {
    Environment  = var.environment
    Project      = var.project_name
    ManagedBy    = var.managed_by
    Region       = var.location
    Subscription = data.azurerm_subscription.current.display_name
    TenantId     = data.azurerm_client_config.current.tenant_id
  }
}

# Static configuration with hardcoded values
resource "azurerm_resource_group" "production" {
  name     = "${var.environment}-resources"
  location = var.location

  tags = local.tags
}

resource "azurerm_virtual_network" "production" {
  name                = "${var.environment}-network"
  resource_group_name = azurerm_resource_group.production.name
  location            = azurerm_resource_group.production.location
  address_space       = var.vnet_address_space

  tags = local.tags
}

resource "azurerm_subnet" "private" {
  name                 = "${var.environment}-subnet"
  resource_group_name  = azurerm_resource_group.production.name
  virtual_network_name = azurerm_virtual_network.production.name
  address_prefixes     = var.subnet_prefix
}