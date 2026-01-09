variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    delegation = optional(object({
      name         = string
      service_name = string
      actions      = optional(list(string), [])
    }))
    service_endpoints = optional(list(string), [])
    associate_nsg     = optional(bool, true)
  }))
  default = []
}

variable "create_default_nsg" {
  description = "Create a default NSG"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Create a NAT Gateway"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
