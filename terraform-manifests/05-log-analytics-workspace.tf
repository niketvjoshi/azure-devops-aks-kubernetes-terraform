# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "${var.environment}-${var.business_unit}-${var.project}-${var.location}-log-analytics-workspace"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  retention_in_days   = 30
}