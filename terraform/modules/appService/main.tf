resource "azurerm_app_service" "app_service" {
  name                = var.app_service_name
  location            = var.location_name
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  tags                = var.tags

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.setting_APPINSIGHTS_INSTRUMENTATIONKEY
    VaultUri = var.setting_VaultUri
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.setting_APPLICATIONINSIGHTS_CONNECTION_STRING
    # EventHubName = var.setting_EventHubName
    # EventHubConnectionString = var.setting_EventHubConnectionString
  }


   #appsrv_settings = var.appsrv_settings
  #  site_config {
  #    vnet_route_all_enabled = var.vnet_route_all_enabled
  #  }
  

  identity {
    type = "SystemAssigned"
  }

  # depends_on = [
  #   azurerm_app_service_plan.appServicePlan
  # ]
}
