terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
  
  # Uncomment and configure for remote state storage
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "terraformstatestorage"
  #   container_name       = "tfstate"
  #   key                  = "blackjack.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "blackjack" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.tags
}

# Container Registry
resource "azurerm_container_registry" "blackjack" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.blackjack.name
  location            = azurerm_resource_group.blackjack.location
  sku                 = "Standard"
  admin_enabled       = false
  
  tags = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "blackjack" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.blackjack.location
  resource_group_name = azurerm_resource_group.blackjack.name
  dns_prefix          = var.aks_dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = var.tags
}

# Role assignment for AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.blackjack.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.blackjack.id
  skip_service_principal_aad_check = true
}

# Application Insights
resource "azurerm_application_insights" "blackjack" {
  name                = "${var.project_name}-insights"
  location            = azurerm_resource_group.blackjack.location
  resource_group_name = azurerm_resource_group.blackjack.name
  application_type    = "web"

  tags = var.tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "blackjack" {
  name                = "${var.project_name}-logs"
  location            = azurerm_resource_group.blackjack.location
  resource_group_name = azurerm_resource_group.blackjack.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}