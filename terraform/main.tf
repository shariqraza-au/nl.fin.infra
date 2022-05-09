data "azurerm_client_config" "current" {}

#Shared DNS Details
data "azurerm_private_dns_zone" "shared_private_dns_zone_azurewebsites" {
  provider            = azurerm.shared
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.shared_resource_group_name
}

data "azurerm_private_dns_zone" "shared_private_dns_zone_vaultcore" {
  provider            = azurerm.shared
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.shared_resource_group_name
}

data "azurerm_private_dns_zone" "shared_private_dns_zone_blob" {
  provider            = azurerm.shared
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.shared_resource_group_name
}

data "azurerm_private_dns_zone" "shared_private_dns_zone_documents" {
  provider            = azurerm.shared
  name                = "privatelink.documents.azure.com"
  resource_group_name = var.shared_resource_group_name
}

data "azurerm_private_dns_zone" "shared_private_dns_zone_database" {
  provider            = azurerm.shared
  name                = "privatelink.database.windows.net"
  resource_group_name = var.shared_resource_group_name
}

data "azurerm_private_dns_zone" "shared_private_dns_zone_servicebus" {
  provider            = azurerm.shared
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = var.shared_resource_group_name
}

#Redis
data "azurerm_private_dns_zone" "shared_private_dns_zone_rediscache" {
  provider            = azurerm.shared
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.shared_resource_group_name
}

locals {
    product_env_tags_map = merge({
            Business_Unit = var.business_unit
            Environment = var.environment
            Purpose = var.purpose
            Team = var.team_Name
            Team_Contact = var.team_contact
    })
}

#create App Service plan
module "appServicePlan" {
  source              = "./modules/appsrvPlan"
  asp_name            = var.asp_name
  location_name       = var.location_name
  resource_group_name = var.resource_group_name
  asp_tier            = var.asp_tier
  asp_size            = var.asp_size
  tags                = local.product_env_tags_map
}

#create App Service plan boq consumer notification
module "appServicePlan_consumer_notification" {
  source              = "./modules/appsrvPlan"
  asp_name            = var.asp_cons_notf_name
  location_name       = var.location_name
  resource_group_name = var.resource_group_name
  asp_tier            = var.asp_tier
  asp_size            = var.asp_size
  tags                = local.product_env_tags_map
}

module "appInsights" {
  source              = "./modules/appInsights"
  resource_group_name = var.resource_group_name
  location_name       = var.location_name
  # shared_workspace_name       = var.shared_workspace_name
  # shared_resource_group_name  = var.shared_resource_group_name
  appInsight_name                          = var.appInsight_name
  log_analytics_workspace_name             = var.log_analytics_workspace_name
  log_analytics_sku                        = var.log_analytics_sku
  log_analytics_retention_in_days          = var.log_analytics_retention_in_days
  log_analytics_daily_quota_in_gb          = var.log_analytics_daily_quota_in_gb
  log_analytics_internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled
  log_analytics_internet_query_enabled     = var.log_analytics_internet_query_enabled
  tags                                     = local.product_env_tags_map
}


#Create Cosmos DB
module "cosmosDB" {
  source                      = "./modules/cosmosDB"
  resource_group_name         = var.resource_group_name
  location_name               = var.location_name
  cosmosdb_name               = var.cosmosdb_name
  offer_type                  = var.offer_type
  #public_network_access       = true
  app_subnetid                = var.app_subnetid
  mmsg_ip_allow               = var.mmsg_ip_allow
  tags                        = local.product_env_tags_map
}

# #Private EP for Cosmos DB
# module "fnCosmosPvtEP" {
#   source                        = "./modules/pvtEP"
#   pvt_endpoint_name             = var.pvtendpoint_cosmosdb
#   location_name                 = var.location_name
#   resource_group_name           = var.resource_group_name
#   subnet_id                     = var.pvt_subnetid
#   pvtsrvconn_name               = var.pvtsrvconn_cosmosdb_name
#   private_connection_resource_id = module.cosmosDB.cosmosdb_account_output.id
#   subresource_names             = var.subresource_cosmosdb_names
#   depends_on                    = [module.cosmosDB]
#   private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_documents.id]
# }

#Redis Cache
module "redis_cache" {
  source                                = "./modules/redisCache"
  redis_CacheName                       = var.redis_CacheName
  location_name                         = var.location_name
  resource_group_name                   = var.resource_group_name
  redis_sku_capacity                    = var.redis_sku_capacity
  redis_sku_family                      = var.redis_sku_family
  redis_sku_type                        = var.redis_sku_type
  redis_enable_non_ssl_port             = var.redis_enable_non_ssl_port
  redis_minimum_tls_version             = var.redis_minimum_tls_version
  redis_public_network_access_enabled   = var.redis_public_network_access_enabled
  redis_config_maxmemory_reserved       = var.redis_config_maxmemory_reserved
  redis_maxfragmentationmemory_reserved = var.redis_maxfragmentationmemory_reserved
  redis_maxmemory_policy                = var.redis_maxmemory_policy
  redis_version                         = var.redis_version
  redis_patching_day                    = var.redis_patching_day
  redis_patching_time_in_utc            = var.redis_patching_time_in_utc
  tags                                  = local.product_env_tags_map

}

#Private End point for Redis Cache
module "redis_cache_EP" {
  source                         = "./modules/pvtEP"
  pvt_endpoint_name              = var.pvtendpoint_redis_cache_name
  location_name                  = var.location_name
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.pvt_subnetid
  pvtsrvconn_name                = var.pvtsrvconn_redis_cache_name
  private_connection_resource_id = module.redis_cache.redis_cache_output.id
  subresource_names              = var.subresource_redis_cache
  depends_on                     = [module.redis_cache]
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.shared_private_dns_zone_rediscache.id]
}



#Storage account for Az Functions creation
module "storageAccount" {
    source                      = "./modules/storageAcc"
    storageAccount_name         = var.storageAccount_name
    resource_group_name         = var.resource_group_name
    location_name               = var.location_name
    storageAccount_account_tier = var.storageAccount_account_tier
    account_replication_type    = var.account_replication_type
    mmsg_ip_allow               = var.mmsg_ip_allow
    app_subnetid                = var.app_subnetid
    tags                        = local.product_env_tags_map
}

#Private EP for Storage Account
module "fnStrgPvtEP" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pvtendpoint_fn_storage
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.pvtsrvconn_fnstrg_name
  private_connection_resource_id = module.storageAccount.storage_account_output.id
  subresource_names             = var.subresource_strg_names
  depends_on                    = [module.storageAccount]
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_blob.id]
}
#storageAccount_Audit
module "auditstorageAccount" {
    source                      = "./modules/storageAcc"
    storageAccount_name         = var.storageAccount_audit_name
    resource_group_name         = var.resource_group_name
    location_name               = var.location_name
    storageAccount_account_tier = var.storageAccount_account_tier
    account_replication_type    = var.account_replication_type
    mmsg_ip_allow               = var.mmsg_ip_allow
    app_subnetid                = var.app_subnetid
    tags                        = local.product_env_tags_map
}

#Private EP for Storage Account
module "audStrgPvtEP" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pvtendpoint_aud_storage
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.pvtsrvconn_audstrg_name
  private_connection_resource_id = module.storageAccount.storage_account_output.id
  subresource_names             = var.subresource_strg_names
  depends_on                    = [module.storageAccount]
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_blob.id]
}

 #Create Function angle_consumer_adapter
module "angle_consumer_adapter" {
    source                     = "./modules/functionApp"
    azfunc_name                = var.azfn_angle_consumer_adapter_name
    location_name              = var.location_name
    resource_group_name        = var.resource_group_name
    app_service_plan_id        = module.appServicePlan.app_service_plan_output.id
    storage_account_name       = module.storageAccount.storage_account_output.name
    storage_account_access_key = module.storageAccount.storage_account_output.primary_access_key
    setting_AzureWebJobsStorage = module.storageAccount.storage_account_output.primary_access_key
    setting_APPINSIGHTS_INSTRUMENTATIONKEY = module.appInsights.app_insights_output.instrumentation_key
    setting_APPLICATIONINSIGHTS_CONNECTION_STRING = module.appInsights.app_insights_output.connection_string
    setting_VaultUri = module.key_vault.key_vault_output.vault_uri
    # setting_EventHubName = var.eventHub_name
    # setting_EventHubConnectionString = module.eventHubNS.eventhub_ns_output.default_primary_key
    tags                        = local.product_env_tags_map
    depends_on = [ module.appServicePlan, module.storageAccount, module.appInsights, module.key_vault ]#, module.eventHubNS ]
}

 #Create Function boq_consumer_adapter
module "boq_consumer_adapter" {
    source                     = "./modules/functionApp"
    azfunc_name                = var.azfn_boq_consumer_adapter_name
    location_name              = var.location_name
    resource_group_name        = var.resource_group_name
    app_service_plan_id        = module.appServicePlan.app_service_plan_output.id
    storage_account_name       = module.storageAccount.storage_account_output.name
    storage_account_access_key = module.storageAccount.storage_account_output.primary_access_key
    setting_AzureWebJobsStorage = module.storageAccount.storage_account_output.primary_access_key
    setting_APPINSIGHTS_INSTRUMENTATIONKEY = module.appInsights.app_insights_output.instrumentation_key
    setting_APPLICATIONINSIGHTS_CONNECTION_STRING = module.appInsights.app_insights_output.connection_string
    setting_VaultUri = module.key_vault.key_vault_output.vault_uri
    # setting_EventHubName = var.eventHub_name
    # setting_EventHubConnectionString = module.eventHubNS.eventhub_ns_output.default_primary_key
    tags                        = local.product_env_tags_map
    depends_on = [ module.appServicePlan, module.storageAccount, module.appInsights, module.key_vault ]
}

 #Create Function boq_consumer_notification_adapter
module "boq_consumer_notification_adapter" {
    source                     = "./modules/functionApp"
    azfunc_name                = var.azfn_boq_consumer_notification_adapter_name
    location_name              = var.location_name
    resource_group_name        = var.resource_group_name
    app_service_plan_id        = module.appServicePlan_consumer_notification.app_service_plan_output.id
    storage_account_name       = module.storageAccount.storage_account_output.name
    storage_account_access_key = module.storageAccount.storage_account_output.primary_access_key
    setting_AzureWebJobsStorage = module.storageAccount.storage_account_output.primary_access_key
    setting_APPINSIGHTS_INSTRUMENTATIONKEY = module.appInsights.app_insights_output.instrumentation_key
    setting_APPLICATIONINSIGHTS_CONNECTION_STRING = module.appInsights.app_insights_output.connection_string
    setting_VaultUri = module.key_vault.key_vault_output.vault_uri
    # setting_EventHubName = var.eventHub_name
    # setting_EventHubConnectionString = module.eventHubNS.eventhub_ns_output.default_primary_key
    tags                        = local.product_env_tags_map
    depends_on = [ module.appServicePlan_consumer_notification, module.storageAccount, module.appInsights, module.key_vault ]
}

 #Create Function d365_adapter
module "d365_adapter" {
    source                     = "./modules/functionApp"
    azfunc_name                = var.azfn_d365_adapter_name
    location_name              = var.location_name
    resource_group_name        = var.resource_group_name
    app_service_plan_id        = module.appServicePlan.app_service_plan_output.id
    storage_account_name       = module.storageAccount.storage_account_output.name
    storage_account_access_key = module.storageAccount.storage_account_output.primary_access_key
    setting_AzureWebJobsStorage = module.storageAccount.storage_account_output.primary_access_key
    setting_APPINSIGHTS_INSTRUMENTATIONKEY = module.appInsights.app_insights_output.instrumentation_key
    setting_APPLICATIONINSIGHTS_CONNECTION_STRING = module.appInsights.app_insights_output.connection_string
    setting_VaultUri = module.key_vault.key_vault_output.vault_uri
    # setting_EventHubName = var.eventHub_name
    # setting_EventHubConnectionString = module.eventHubNS.eventhub_ns_output.default_primary_key
    tags                        = local.product_env_tags_map
    depends_on = [ module.appServicePlan, module.storageAccount, module.appInsights, module.key_vault ]# ]
}

 #Create Function finance_adapter
module "finance_adapter" {
    source                     = "./modules/functionApp"
    azfunc_name                = var.azfn_fin_adapter_name
    location_name              = var.location_name
    resource_group_name        = var.resource_group_name
    app_service_plan_id        = module.appServicePlan.app_service_plan_output.id
    storage_account_name       = module.storageAccount.storage_account_output.name
    storage_account_access_key = module.storageAccount.storage_account_output.primary_access_key
    setting_AzureWebJobsStorage = module.storageAccount.storage_account_output.primary_access_key
    setting_APPINSIGHTS_INSTRUMENTATIONKEY = module.appInsights.app_insights_output.instrumentation_key
    setting_APPLICATIONINSIGHTS_CONNECTION_STRING = module.appInsights.app_insights_output.connection_string
    setting_VaultUri = module.key_vault.key_vault_output.vault_uri
    # setting_EventHubName = var.eventHub_name
    # setting_EventHubConnectionString = module.eventHubNS.eventhub_ns_output.default_primary_key
    tags                        = local.product_env_tags_map
    depends_on = [ module.appServicePlan, module.storageAccount, module.appInsights, module.key_vault ]# ]
}

#Vnet Integration for Azure Function angle_consumer_adapter
resource "azurerm_app_service_virtual_network_swift_connection" "angle_consumer_adapter" {
  app_service_id = module.angle_consumer_adapter.function_app_output.id
  subnet_id      = var.app_subnetid
}

#Vnet Integration for Azure Function boq_consumer_adapter
resource "azurerm_app_service_virtual_network_swift_connection" "boq_consumer_adapter" {
  app_service_id = module.boq_consumer_adapter.function_app_output.id
  subnet_id      = var.app_subnetid
}

#Vnet Integration for Azure Function d365_adapter
resource "azurerm_app_service_virtual_network_swift_connection" "d365_adapter" {
  app_service_id = module.d365_adapter.function_app_output.id
  subnet_id      = var.app_subnetid
}

#Vnet Integration for Azure Function finance_adapter
resource "azurerm_app_service_virtual_network_swift_connection" "finance_adapter" {
  app_service_id = module.finance_adapter.function_app_output.id
  subnet_id      = var.app_subnetid
}

# #Vnet Integration for Azure Function boq_consumer_notification_adapter
# resource "azurerm_app_service_virtual_network_swift_connection" "boq_consumer_notification_adapter" {
#   app_service_id = module.boq_consumer_notification_adapter.function_app_output.id
#   subnet_id      = var.app_subnetid
# }

#Vnet Integration for App Service
resource "azurerm_app_service_virtual_network_swift_connection" "appSrv_vnet_integration" {
  app_service_id = module.AppService.azurerm_app_service_output.id
  subnet_id      = var.app_subnetid
}

#Create App Service

module "AppService" {
  source                      = "./modules/appService"
  app_service_name            = var.app_service_name
  location_name               = var.location_name
  resource_group_name         = var.resource_group_name
  app_service_plan_id         = module.appServicePlan.app_service_plan_output.id
  setting_APPINSIGHTS_INSTRUMENTATIONKEY = module.appInsights.app_insights_output.instrumentation_key
  setting_APPLICATIONINSIGHTS_CONNECTION_STRING = module.appInsights.app_insights_output.connection_string
  setting_VaultUri = module.key_vault.key_vault_output.vault_uri
  # setting_EventHubName = var.eventHub_name
  # setting_EventHubConnectionString = module.eventHubNS.eventhub_ns_output.default_primary_key
  tags                        = local.product_env_tags_map
  depends_on = [ module.appServicePlan, module.appInsights, module.key_vault ]# ]
}

#Private Endpoint for Azure Function angle_consumer_adapter
module "fnPvtEP_angle_consumer_adapter" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pe_fn_angleconsumeradapter_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.peconn_fn_angle_consumer_adapter_name
  private_connection_resource_id = module.angle_consumer_adapter.function_app_output.id
  subresource_names             = var.subresource_fn_angle_consumer_adapter_names
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_azurewebsites.id]
}

#Private Endpoint for Azure Function boq_consumer_adapter
module "fnPvtEP_boq_consumer_adapter" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pe_fn_boqconsumeradapter_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.peconn_fn_boq_consumer_adapter_name
  private_connection_resource_id = module.boq_consumer_adapter.function_app_output.id
  subresource_names             = var.subresource_fn_boq_consumer_adapter_names
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_azurewebsites.id]
}

#Private Endpoint for Azure Function boq_consumer_notification_adapter
module "fnPvtEP_boq_consumer_notification_adapter" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pe_fn_boqconsumernotificationadapter_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.peconn_fn_boq_consumer_notification_adapter_name
  private_connection_resource_id = module.boq_consumer_notification_adapter.function_app_output.id
  subresource_names             = var.subresource_fn_boq_consumer_notification_adapter_names
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_azurewebsites.id]
}

#Private Endpoint for Azure Function d365_adapter
module "fnPvtEP_d365_adapter" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pe_fn_d365adapter_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.peconn_fn_d365_adapter_name
  private_connection_resource_id = module.d365_adapter.function_app_output.id
  subresource_names             = var.subresource_fn_d365_adapter_names
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_azurewebsites.id]
}

#Private Endpoint for Azure Function finance_adapter
module "fnPvtEP_finance_adapter" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pe_fn_financeadapter_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.peconn_fn_finance_adapter_name
  private_connection_resource_id = module.finance_adapter.function_app_output.id
  subresource_names             = var.subresource_fn_finance_adapter_names
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_azurewebsites.id]
}

#Create Service Bus
module "service_bus" {
  source                      = "./modules/serviceBus" 
  servicebus_name             = var.servicebus_name
  resource_group_name         = var.resource_group_name
  location_name               = var.location_name
  servicebus_sku_type         = var.servicebus_sku_type
  tags                        = local.product_env_tags_map
}


#Create Key Vault
module "key_vault" {
    source                      = "./modules/keyvault" 
    resource_group_name         = var.resource_group_name
    location_name               = var.location_name
    keyvalut_name               = var.keyvalut_name
    tenant_id                   = var.tenant_id #data.azurerm_client_config.current.tenant_id
    keyvalut_sku_name           = var.keyvalut_sku_name #"standard"
    current_object_id           = data.azurerm_client_config.current.object_id
    app_subnetid                = var.app_subnetid
    mmsg_ip_allow               = var.mmsg_ip_allow
    tags                        = local.product_env_tags_map
}

# #Values build locally
# module "key_vault_secret_0" {
#   source       = "./modules/keyvaultSecret"
#   key_vault_id = module.key_vault.key_vault_output.id
#   sect_maps    = local.loc_sect_maps

#   depends_on               = [module.SPN_KV_AccessPolicy]
# }
# #Values coming from Library secret variable
# module "key_vault_secret_1" {
#   source       = "./modules/keyvaultSecret"
#   key_vault_id = module.key_vault.key_vault_output.id
#   sect_maps    = var.sect_maps

#   depends_on               = [module.SPN_KV_AccessPolicy]
# }

# #Secret for AuthServer
# locals {
#   loc_sect_maps_authserver = merge(
#     var.sect_maps_authserver
#   )
# }

module "appsrvAccessPolicy" {
  source                   = "./modules/kvAccessPolicy"
  key_vault_id             = module.key_vault.key_vault_output.id
  tenant_id                = var.tenant_id
  functionapp_principal_id = module.AppService.azurerm_app_service_output.identity.0.principal_id
  depends_on               = [module.key_vault, module.AppService]
}

#Function App Key Valut Access Policy
module "fnapp_angle_vault_access_policy" {
    source                      = "./modules/kvAccessPolicy"
    key_vault_id                = module.key_vault.key_vault_output.id
    tenant_id                   = var.tenant_id
    functionapp_principal_id    = module.angle_consumer_adapter.function_app_output.identity[0].principal_id
    depends_on = [
      module.key_vault,
      module.angle_consumer_adapter
    ]
}

module "fnapp_boq_vault_access_policy" {
    source                      = "./modules/kvAccessPolicy"
    key_vault_id                = module.key_vault.key_vault_output.id
    tenant_id                   = var.tenant_id
    functionapp_principal_id    = module.boq_consumer_adapter.function_app_output.identity[0].principal_id
    depends_on = [
      module.key_vault,
      module.boq_consumer_adapter
    ]
}

module "fnapp_d365_vault_access_policy" {
    source                      = "./modules/kvAccessPolicy"
    key_vault_id                = module.key_vault.key_vault_output.id
    tenant_id                   = var.tenant_id
    functionapp_principal_id    = module.d365_adapter.function_app_output.identity[0].principal_id
    depends_on = [
      module.key_vault,
      module.d365_adapter
    ]
}

module "fnapp_finance_vault_access_policy" {
    source                      = "./modules/kvAccessPolicy"
    key_vault_id                = module.key_vault.key_vault_output.id
    tenant_id                   = var.tenant_id
    functionapp_principal_id    = module.finance_adapter.function_app_output.identity[0].principal_id
    depends_on = [
      module.key_vault,
      module.finance_adapter
    ]
}


# #Add SPN to KV Access Policy
# module "SPN_KV_AccessPolicy" {
#   source                   = "./modules/kvAccessPolicy"
#   key_vault_id             = module.key_vault.key_vault_output.id
#   tenant_id                = var.tenant_id
#   functionapp_principal_id = data.azurerm_client_config.current.object_id
# }

# module "appsrvAccessPolicy" {
#   source                        = "./modules/kvAccessPolicy"
#   key_vault_id                  = module.key_vault.key_vault_output.id
#   tenant_id                     = var.tenant_id
#   functionapp_principal_id      = module.AppService.azurerm_app_service_output.identity[0].principal_id
#   depends_on = [ module.AppService ]
# }

#Private Endpoint for Key Vault
module "kvPvtEP" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pvtendpoint_kv_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.pvtsrvconn_kv_name
  private_connection_resource_id = module.key_vault.key_vault_output.id
  subresource_names             = var.subresource_kv_names
  depends_on                    = [module.key_vault] #, module.SPN_KV_AccessPolicy]
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_vaultcore.id]
}

#Private End point for App Service
module "appSrvEP" {
  source                        = "./modules/pvtEP"
  pvt_endpoint_name             = var.pvtendpoint_appsrv_name
  location_name                 = var.location_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.pvt_subnetid
  pvtsrvconn_name               = var.pvtsrvconn_appsrv_name
  private_connection_resource_id = module.AppService.azurerm_app_service_output.id
  subresource_names             = var.subresource_appsrv_names
  depends_on                    = [module.AppService]
  private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_azurewebsites.id]
}

# module "eventHubNS" {
#   source                        = "./modules/eventHubNmspc"
#   namespace_name                = var.namespace_name
#   location_name                 = var.location_name
#   resource_group_name           = var.resource_group_name
#   namespace_sku                 = var.namespace_sku
#   namespace_capacity            = var.namespace_capacity
#   eventHub_name                 = var.eventHub_name
#   message_retention             = var.message_retention
#   tags                          = local.product_env_tags_map
#   app_subnetid                  = var.app_subnetid
#   pvt_ep_subnet_address         = var.pvt_ep_subnet_address
# }

# #Private End point for Event Hub Namespace
# module "eventHubEP" {
#   source                        = "./modules/pvtEP"
#   pvt_endpoint_name             = var.pvtendpoint_ehns_name
#   location_name                 = var.location_name
#   resource_group_name           = var.resource_group_name
#   subnet_id                     = var.pvt_subnetid
#   pvtsrvconn_name               = var.pvtsrvconn_ehns_name
#   private_connection_resource_id = module.eventHubNS.eventhub_ns_output.id
#   subresource_names             = var.subresource_ehns_names
#   depends_on                    = [module.eventHubNS]
#   private_dns_zone_ids          = [data.azurerm_private_dns_zone.shared_private_dns_zone_servicebus.id]
# }

# resource "azurerm_role_assignment" "ra-apsrv-cosmosdb-contributor" {
#   scope                = module.cosmosDB.cosmosdb_account_output.id
#   role_definition_name = "Contributor"
#   principal_id         = module.AppService.azurerm_app_service_output.identity[0].principal_id
# }

#App Configuration
resource "azurerm_app_configuration" "appconfig" {
  name                = var.app_config_name
  resource_group_name = var.resource_group_name
  location            = var.location_name
  sku                 = var.app_config_sku_type
  tags                = local.product_env_tags_map
  
  identity {
    type = "SystemAssigned"
  }
}

