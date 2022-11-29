resource "azurerm_private_dns_zone" "pvt-dns" {
  name                    = "privatelink.centralindia.azmk8s.io"
  resource_group_name     = azurerm_resource_group.aks_rg.name
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  dns_prefix              = "${var.environment}-${var.business_unit}-${var.project}-${var.location}-pvtendpoint"
  location                = azurerm_resource_group.aks_rg.location
  name                    = "${var.environment}-${var.business_unit}-${var.project}-${var.location}-${var.type}"
  resource_group_name     = azurerm_resource_group.aks_rg.name
  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.pvt-dns.id
  kubernetes_version      = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group     = "${azurerm_resource_group.aks_rg.name}-nrg"


  default_node_pool {
    name                  = "systempool"
    vm_size               = "Standard_F4s_v2"
    orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
    #availability_zones   = [1, 2, 3]
    enable_auto_scaling   = true
    max_count             = 3
    min_count             = 1
    os_disk_size_gb       = 30
    type                  = "VirtualMachineScaleSets"
    vnet_subnet_id        = "/subscriptions/999b8920-0f23-42c6-ab0e-6bc472f80616/resourceGroups/staging-exampledotcom-devops-resource-group/providers/Microsoft.Network/virtualNetworks/staging-exampledotcom-devops-virtual-network/subnets/staging-exampledotcom-k8s-centralindia-subnet" 
    node_labels = {
      "nodepool-type"     = "system"
      "environment"       = var.environment
      "nodepoolos"        = "linux"
      "app"               = "system-apps"
    }

  tags = local.tags
  
  }

# Identity (System Assigned or Service Principal)
  /*identity { 
    type          = "UserAssigned"
    #identity_ids  = "/subscriptions/999b8920-0f23-42c6-ab0e-6bc472f80616/resourcegroups/staging-exampledotcom-devops-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/exampledotcom-identity"
    }
*/
  service_principal {
    client_id     = "57eaae81-c052-4174-a049-6051ee2eadca"
    client_secret = "86fnQ~3YZ5aaiYzC5MKtIhWQZbXcAiYgYlRnib0a"
  }
# Description: exampledotcom-sp (Object ID of Service Principal is its client id)

# Add On Profiles
  addon_profile {
    azure_policy { enabled = true }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }

# RBAC and Azure AD Integration Block
role_based_access_control {
  enabled = true
  azure_active_directory {
    managed                = true
    admin_group_object_ids = [azuread_group.aks_administrators.id]
  }
}  

# Windows Admin Profile
windows_profile {
  admin_username            = var.windows_admin_username
  admin_password            = var.windows_admin_password
}

# Linux Profile
linux_profile {
  admin_username = "ubuntu"
  ssh_key {
      key_data = file(var.ssh_public_key)
  }
}

# Network Profile
network_profile {
  load_balancer_sku = "Standard"
  network_plugin = "azure"
}

# AKS Cluster Tags 
tags = local.tags

}