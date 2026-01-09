# Azure AKS Module

Creates an AKS cluster with managed node pools.

## Features

- System-assigned managed identity
- OIDC issuer for workload identity
- Azure CNI network plugin
- Optional autoscaling
- Additional node pools

## Usage

```hcl
module "aks" {
  source = "github.com/galleio-org/terraform-modules-azure//aks?ref=v1.0.0"

  cluster_name        = "my-cluster"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.main.name
  kubernetes_version  = "1.28"
  
  subnet_id   = module.vnet.subnet_ids["aks-subnet"]
  node_count  = 3
  vm_size     = "Standard_D2s_v3"
  
  enable_auto_scaling = true
  min_count           = 1
  max_count           = 10
}
```
