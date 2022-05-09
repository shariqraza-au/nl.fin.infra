resource "azurerm_key_vault" "keyvalut" {
  name                = var.keyvalut_name
  location            = var.location_name
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id #data.azurerm_client_config.current.tenant_id
  sku_name            = var.keyvalut_sku_name #"standard"
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
  tags                = var.tags

  # access_policy = [ {
  #   tenant_id = var.tenant_id
  #   object_id = var.current_object_id #data.azurerm_client_config.current.object_id
  #   application_id = ""
  #   certificate_permissions = []
  #   storage_permissions = []
  #   key_permissions = [
  #   "get", "list"
  #   ]

  #   secret_permissions = [
  #   "set", "get", "list"
  #   ]
  # } ]

  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
    virtual_network_subnet_ids = [var.app_subnetid]
    ip_rules = var.mmsg_ip_allow
  }
}


