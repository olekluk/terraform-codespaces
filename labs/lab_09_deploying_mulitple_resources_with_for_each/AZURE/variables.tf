variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "vnet_count" {
  type    = number
  default = 2
}
# Keep the list variables for comparison
variable "vnet_cidr_blocks" {
  description = "CIDR blocks for virtual networks"
  type        = list(string)
  default     = ["10.0.0.0/16", "10.2.0.0/16"]
}

# New map variables for for_each
variable "vnet_config" {
  description = "Map of virtual network configurations"
  type        = map(string)
  default = {
    "production"  = "10.10.0.0/16"
    "staging"     = "10.11.0.0/16"
    "development" = "10.12.0.0/16"
  }
}

variable "subnet_config" {
  description = "Map of subnet configurations"
  type        = map(string)
  default = {
    "web"  = "10.10.1.0/24"
    "app"  = "10.10.2.0/24"
    "data" = "10.10.3.0/24"
  }
}

variable "nsg_ports_map" {
  description = "Map of NSG ports"
  type        = map(number)
  default = {
    "http"  = 80
    "https" = 443
    "app"   = 8080
    "db"    = 3306
    "redis" = 6379
  }
}