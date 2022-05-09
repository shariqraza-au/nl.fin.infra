# data "azurerm_log_analytics_workspace" "workspace" {
#   provider = azurerm.module_shared
#   name                = var.shared_workspace_name
#   resource_group_name = var.shared_resource_group_name
# }

resource "azurerm_log_analytics_workspace" "logAnalytics" {
  name                       = var.log_analytics_workspace_name
  location                   = var.location_name
  resource_group_name        = var.resource_group_name
  sku                        = var.log_analytics_sku
  retention_in_days          = var.log_analytics_retention_in_days
  daily_quota_gb             = var.log_analytics_daily_quota_in_gb
  internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled
  internet_query_enabled     = var.log_analytics_internet_query_enabled
  tags                       = var.tags
}


resource "azurerm_application_insights" "appInsight" {
  name                = var.appInsight_name
  location            = var.location_name
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.logAnalytics.id
  application_type    = "web"
  tags                = var.tags
}

# module "global_vars" {
#   source              = "../globalVariables"
# }
