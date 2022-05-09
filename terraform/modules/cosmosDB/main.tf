locals {
  #var1  = substr(var.mmsg_ip_allow,1,(length(var.mmsg_ip_allow)-1))
  var1  = join(",",var.mmsg_ip_allow)
}

resource "azurerm_cosmosdb_account" "db" {
  name                = var.cosmosdb_name
  location            = var.location_name
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type #"Standard"
  kind                = "GlobalDocumentDB"
  tags                = var.tags
  #public_network_access_enabled = true #var.public_network_access
  is_virtual_network_filter_enabled = true
  network_acl_bypass_for_azure_services = true
  virtual_network_rule {
    id = var.app_subnetid
  }
  consistency_policy {
    consistency_level       = "SESSION"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }
  identity {
    type = "SystemAssigned"
  }
  geo_location {
    location          = var.location_name
    failover_priority = 0
  }
  ip_range_filter = local.var1
}
