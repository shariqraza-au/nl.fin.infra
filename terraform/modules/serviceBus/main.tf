#ServiceBus creation
resource "azurerm_servicebus_namespace" "servicebus" {
  name                     = var.servicebus_name
  resource_group_name      = var.resource_group_name
  location                 = var.location_name
  sku                      = var.servicebus_sku_type        
  tags                     = var.tags
}