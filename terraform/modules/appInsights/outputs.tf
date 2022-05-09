output "app_insights_output" {
  value       = azurerm_application_insights.appInsight
  description = "App Insights provisioning"
  sensitive   = true
}

output "log_analytics_workspace_output" {
  value       = azurerm_log_analytics_workspace.logAnalytics
  description = "Log analytics Provisioning"
  sensitive   = true
}
