resource "azurerm_eventhub_namespace" "eventHubNS" {
  name                = var.namespace_name
  location            = var.location_name
  resource_group_name = var.resource_group_name
  sku                 = var.namespace_sku #"Standard"
  capacity            = var.namespace_capacity #2

  network_rulesets = [{
    default_action = "Deny"
    trusted_service_access_enabled = true
    ip_rule = [{
      action  = "Allow"
      ip_mask = var.pvt_ep_subnet_address
    }]
    virtual_network_rule = [{
      ignore_missing_virtual_network_service_endpoint = true
      subnet_id                                       = var.app_subnetid
    }]
  }]

  tags = var.tags
}

resource "azurerm_eventhub" "eventHub" {
  name                = var.eventHub_name
  namespace_name      = azurerm_eventhub_namespace.eventHubNS.name
  resource_group_name = var.resource_group_name
  partition_count     = 2 #cannot be changed except premium
  message_retention   = var.message_retention # in days 1 
}
