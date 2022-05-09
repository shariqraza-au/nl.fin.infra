resource "azurerm_app_service_plan" "appServicePlan" {
  name                = var.asp_name
  location            = var.location_name
  resource_group_name = var.resource_group_name

  sku {
    tier = var.asp_tier
    size = var.asp_size
  }
  tags = var.tags
}
