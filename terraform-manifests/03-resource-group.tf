# Terraform Resource to Create Azure Resource Group with Input Variables defined in variables.tf
resource "azurerm_resource_group" "aks_rg" {
  name = "${var.environment}-${var.business_unit}-${var.project}-${var.location}-resource-group"
  location = var.location

tags = local.tags

}

#environment business_unit project location type



