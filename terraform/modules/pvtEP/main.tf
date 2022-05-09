#Create Private Endpoint
resource "azurerm_private_endpoint" "pvtendpoint" {
  name                = var.pvt_endpoint_name
  location            = var.location_name
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id #endpnt_subnetid

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  private_service_connection {
    name                           = var.pvtsrvconn_name
    private_connection_resource_id = var.private_connection_resource_id #azurerm_key_vault.keyvalut.id
    is_manual_connection           = false
    subresource_names              = var.subresource_names #["vault"] ["sites"]
  }
}
