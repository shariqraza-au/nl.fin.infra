#Storage account creation
resource "azurerm_storage_account" "storageAccount" {
  name                     = var.storageAccount_name
  resource_group_name      = var.resource_group_name
  location                 = var.location_name
  account_tier             = var.storageAccount_account_tier
  account_replication_type = var.account_replication_type
    network_rules {
    default_action         = "Deny"
    ip_rules               = var.mmsg_ip_allow
    virtual_network_subnet_ids = [var.app_subnetid]
  }
  tags                = var.tags
}
