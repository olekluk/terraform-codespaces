# Add resources for the lab below

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


# Use join function to create a resource group name
resource "azurerm_resource_group" "main" {
#   name     = "rg-dev"
  name     = join("-", [var.environment, "rg", random_string.suffix.result])        # <-- change this line
  location = var.location

  tags = {
    Environment = var.environment
    Purpose     = "Terraform Function Lab"
  }
}

resource "azurerm_virtual_network" "main" {
  count               = min(length(var.locations), length(var.address_spaces))
  name                = "${var.environment}-vnet-${count.index + 1}"
  location            = var.locations[count.index]
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_spaces[count.index]]

  tags = {
    Name = "${var.environment}-vnet-${count.index + 1}"
  }
}

locals {
  unique_teams = toset(var.teams)
}


resource "azurerm_network_security_group" "example" {
  name                = "${var.environment}-nsg-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Name  = "${var.environment}-nsg"
    Teams = join(", ", local.unique_teams)
    # This joins unique team names with commas
  }
}
