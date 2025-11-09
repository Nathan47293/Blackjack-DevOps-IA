output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.blackjack.name
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.blackjack.name
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.blackjack.fqdn
}

output "acr_login_server" {
  description = "The login server for the Azure Container Registry"
  value       = azurerm_container_registry.blackjack.login_server
}

output "kube_config" {
  description = "The kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.blackjack.kube_config_raw
  sensitive   = true
}

output "application_insights_key" {
  description = "The instrumentation key for Application Insights"
  value       = azurerm_application_insights.blackjack.instrumentation_key
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.blackjack.workspace_id
  sensitive   = true
}