variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "subnet_id" {
  description = "Subnet ID for the default node pool"
  type        = string
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "enable_auto_scaling" {
  description = "Enable autoscaling"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum node count"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum node count"
  type        = number
  default     = 10
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "os_disk_type" {
  description = "OS disk type"
  type        = string
  default     = "Managed"
}

variable "max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 110
}

variable "node_labels" {
  description = "Labels for default node pool"
  type        = map(string)
  default     = {}
}

variable "network_plugin" {
  description = "Network plugin (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy (azure or calico)"
  type        = string
  default     = "azure"
}

variable "outbound_type" {
  description = "Outbound type"
  type        = string
  default     = "loadBalancer"
}

variable "enable_oms_agent" {
  description = "Enable OMS agent"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
  default     = null
}

variable "azure_policy_enabled" {
  description = "Enable Azure Policy"
  type        = bool
  default     = false
}

variable "oidc_issuer_enabled" {
  description = "Enable OIDC issuer"
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "additional_node_pools" {
  description = "Additional node pools"
  type = list(object({
    name               = string
    vm_size            = string
    node_count         = number
    enable_auto_scaling = optional(bool, false)
    min_count          = optional(number)
    max_count          = optional(number)
    mode               = optional(string, "User")
    node_labels        = optional(map(string), {})
    node_taints        = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
