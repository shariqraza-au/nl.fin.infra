resource "azurerm_function_app" "functionapp" {
  name                       = var.azfunc_name
  location                   = var.location_name
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  https_only = true
  version = "~3"
  app_settings = {
    AzureWebJobsStorage = var.setting_AzureWebJobsStorage
    APPINSIGHTS_INSTRUMENTATIONKEY = var.setting_APPINSIGHTS_INSTRUMENTATIONKEY
    VaultUri = var.setting_VaultUri
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.setting_APPLICATIONINSIGHTS_CONNECTION_STRING
    # EventHubName = var.setting_EventHubName
    # EventHubConnectionString = var.setting_EventHubConnectionString
  }

  site_config {
    always_on = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags      = var.tags
}