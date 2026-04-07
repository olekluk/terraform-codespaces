# Resource Group without lifecycle configuration
resource "azurerm_resource_group" "standard" {
  name     = "rg-standard-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Purpose     = "Standard"
  }
}

# Storage Account without lifecycle configuration
resource "azurerm_storage_account" "standard" {
  name                     = "standardsa${formatdate("YYMMDD", timestamp())}"
  resource_group_name      = azurerm_resource_group.standard.name
  location                 = azurerm_resource_group.standard.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Purpose     = "Standard"
  }
}


resource "azurerm_resource_group" "protected" {
  name     = "rg-protected-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Purpose     = "Protected"
  }

  # lifecycle {                      # <--- add this lifecycle block here (all 3 lines)
  #   prevent_destroy = true
  # }
}

resource "azurerm_storage_account" "replacement" {
  name                     = "replacesa${formatdate("YYMMDD", timestamp())}"
  resource_group_name      = azurerm_resource_group.standard.name
  location                 = azurerm_resource_group.standard.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Purpose     = "Replacement"
  }

  lifecycle {
    create_before_destroy = true
  }
}