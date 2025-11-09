variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-blackjack-devops"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "blackjack"
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "acrblackjackdevops"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "aks-blackjack"
}

variable "aks_dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
  default     = "blackjack"
}

variable "node_count" {
  description = "The number of nodes in the AKS default node pool"
  type        = number
  default     = 3
}

variable "node_vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_D2_v2"
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Project     = "Blackjack-DevOps-IA"
    Environment = "Development"
    Owner       = "DevOps-Team"
  }
}