# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "centralindia"
}

#environment business_unit project location type
variable "business_unit" {
  type = string
  description = "Business unit where all these resources will be provisioned"
  default = "exampledotcom"
}

variable "project" {
  type = string
  description = "Project for which all these resources will be provisioned"
  default = "k8s"
}

variable "type" {
  type = string
  description = "Cluster where all these resources will be provisioned"
  default = "cluster"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "terraform-aks"
}

# Azure AKS Environment Name
variable "environment" {
  type = string  
  description = "This variable defines the Environment"  
  default = "staging"
}


# AKS Input Variables

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  #default = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type = string
  default = "azureuser"
  description = "This variable defines the Windows admin username k8s Worker nodes"  
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type = string
  default = "H0pe@NW11082022"
  description = "This variable defines the Windows admin password k8s Worker nodes"  
}

