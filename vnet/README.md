# Azure VNet Module

Creates a Virtual Network with subnets, NSG, and optional NAT Gateway.

## Usage

```hcl
module "vnet" {
  source = "github.com/galleio-org/terraform-modules-azure//vnet?ref=v1.0.0"

  vnet_name           = "my-vnet"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  subnets = [
    {
      name             = "aks-subnet"
      address_prefixes = ["10.0.0.0/22"]
    },
    {
      name             = "app-subnet"
      address_prefixes = ["10.0.4.0/24"]
    }
  ]

  create_nat_gateway = true
}
```
