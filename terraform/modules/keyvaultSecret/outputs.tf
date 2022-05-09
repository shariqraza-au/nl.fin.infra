output "key_vault_output" {
  value       = azurerm_key_vault_secret.secrets
  description = "Key vault secrets provisioning"
}
