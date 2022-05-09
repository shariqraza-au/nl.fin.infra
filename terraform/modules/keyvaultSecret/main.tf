resource "azurerm_key_vault_secret" "secrets" {
  count        = length(var.sect_maps)
  name         = keys(var.sect_maps)[count.index]
  value        = values(var.sect_maps)[count.index]
  key_vault_id = var.key_vault_id

}
