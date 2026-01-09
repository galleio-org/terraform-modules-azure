# GalleIO Azure VNet Module
# Creates a Virtual Network with subnets

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = lookup(delegation.value, "actions", [])
      }
    }
  }

  service_endpoints = lookup(each.value, "service_endpoints", [])
}

# Network Security Group
resource "azurerm_network_security_group" "default" {
  count               = var.create_default_nsg ? 1 : 0
  name                = "${var.vnet_name}-default-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Associate NSG with subnets
resource "azurerm_subnet_network_security_group_association" "default" {
  for_each = var.create_default_nsg ? { for s in var.subnets : s.name => s if lookup(s, "associate_nsg", true) } : {}

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.default[0].id
}

# NAT Gateway (optional)
resource "azurerm_public_ip" "nat" {
  count               = var.create_nat_gateway ? 1 : 0
  name                = "${var.vnet_name}-nat-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "main" {
  count                   = var.create_nat_gateway ? 1 : 0
  name                    = "${var.vnet_name}-nat"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  count                = var.create_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.main[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}
