provider "azurerm" {
    skip_provider_registration = true
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    features {}
}

terraform {
    backend "azurerm"{}
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=2.90.0"
        }
    }
}


provider "azurerm" {
  features {}
  alias = "shared"

  skip_provider_registration = true
  subscription_id            = var.shared_subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  tenant_id                  = var.tenant_id

}