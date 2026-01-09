# GalleIO Azure AKS Module
# Creates an AKS cluster

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix != null ? var.dns_prefix : var.cluster_name

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    vnet_subnet_id      = var.subnet_id
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_count : null
    max_count           = var.enable_auto_scaling ? var.max_count : null
    os_disk_size_gb     = var.os_disk_size_gb
    os_disk_type        = var.os_disk_type
    max_pods            = var.max_pods

    node_labels = var.node_labels
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    load_balancer_sku = "standard"
    outbound_type     = var.outbound_type
  }

  dynamic "oms_agent" {
    for_each = var.enable_oms_agent ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  azure_policy_enabled = var.azure_policy_enabled

  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  tags = var.tags
}

# Additional node pool (optional)
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = { for np in var.additional_node_pools : np.name => np }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  vnet_subnet_id        = var.subnet_id
  enable_auto_scaling   = lookup(each.value, "enable_auto_scaling", false)
  min_count             = lookup(each.value, "min_count", null)
  max_count             = lookup(each.value, "max_count", null)
  mode                  = lookup(each.value, "mode", "User")

  node_labels = lookup(each.value, "node_labels", {})
  node_taints = lookup(each.value, "node_taints", [])

  tags = var.tags
}
