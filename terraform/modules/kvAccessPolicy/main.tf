resource "azurerm_key_vault_access_policy" "kvAccessPolicy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = var.functionapp_principal_id #azurerm_function_app.functionapp.identity[0].principal_id

  key_permissions = [
    "Get", "List"
  ]

  secret_permissions = [
    "Set", "Get", "List"
  ]

  storage_permissions = [
    "Set", "Get", "List"
  ]
  certificate_permissions = [
    "Create", "Get", "List"
  ]

}
