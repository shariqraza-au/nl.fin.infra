# Azure provider variables
variable "subscription_id" {}
variable "subscription_name" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "environment" {}
variable "business_unit" {}
variable "purpose" {}
variable "team_Name" {}
variable "team_contact" {}

variable "shared_resource_group_name" {}
variable "location_name" {}
variable "resource_group_name" {}

variable "asp_name" {}
variable "asp_cons_notf_name" {}
variable "asp_tier" {}
variable "asp_size" {}

# variable "shared_workspace_name" {}
variable "appInsight_name" {}

variable "cosmosdb_name" {}
variable "offer_type" {}
# variable "public_network_access" {
#     type    = bool
# }

# variable "pvtendpoint_cosmosdb" {}
# variable "pvtsrvconn_cosmosdb_name" {}
# variable "subresource_cosmosdb_names" {
#   type = list(string)
# }

#app service
variable "app_service_name" {}
variable "pvtendpoint_appsrv_name" {}
variable "pvtsrvconn_appsrv_name" {}
variable "subresource_appsrv_names" {
  type = list(string)
}

# #AuthServer
# variable "app_service_name_authserver" {}
# variable "pvtendpoint_appsrv_name_authserver" {}
# variable "pvtsrvconn_appsrv_name_authserver" {}
# variable "subresource_appsrv_names_authserver" {
#   type = list(string)
# }


variable "storageAccount_name" {}
variable "storageAccount_audit_name" {}
variable "storageAccount_account_tier" {}
variable "account_replication_type" {}

variable "mmsg_ip_allow" {
   type = list(string)
 }
 variable "app_subnetid" {}
 variable "agent_subnetid" {}
 variable "pvt_subnetid" {}

variable "pvtendpoint_fn_storage" {}
variable "pvtsrvconn_fnstrg_name" {}
variable "subresource_strg_names" {
  type = list(string)
}

variable "pvtendpoint_aud_storage" {}
variable "pvtsrvconn_audstrg_name" {}

variable "azfn_angle_consumer_adapter_name" {}
variable "azfn_boq_consumer_adapter_name" {}
variable "azfn_boq_consumer_notification_adapter_name" {}
variable "azfn_d365_adapter_name" {}
variable "azfn_fin_adapter_name" {}

variable "pe_fn_financeadapter_name" {}
variable "peconn_fn_finance_adapter_name" {}
variable "subresource_fn_finance_adapter_names" {
    type    = list(string)
}

variable "pe_fn_d365adapter_name" {}
variable "peconn_fn_d365_adapter_name" {}
variable "subresource_fn_d365_adapter_names" {
    type    = list(string)
}
variable "pe_fn_boqconsumeradapter_name" {}
variable "peconn_fn_boq_consumer_adapter_name" {}
variable "subresource_fn_boq_consumer_adapter_names" {
    type    = list(string)
}

variable "pe_fn_boqconsumernotificationadapter_name" {}
variable "peconn_fn_boq_consumer_notification_adapter_name" {}
variable "subresource_fn_boq_consumer_notification_adapter_names" {
    type    = list(string)
}

variable "pe_fn_angleconsumeradapter_name" {}
variable "peconn_fn_angle_consumer_adapter_name" {}
variable "subresource_fn_angle_consumer_adapter_names" {
    type    = list(string)
}

variable "pvtendpoint_kv_name" {}
variable "pvtsrvconn_kv_name" {}
variable "subresource_kv_names" {
  type = list(string)
}

variable "keyvalut_name" {}
variable "keyvalut_sku_name" {}

variable "namespace_name" {}
variable "namespace_sku" {}
variable "namespace_capacity" {}
variable "eventHub_name" {}
variable "message_retention" {}
variable "pvt_ep_subnet_address" {}

variable "pvtendpoint_ehns_name" {}
variable "pvtsrvconn_ehns_name" {}
variable "subresource_ehns_names" {
  type    = list(string)
}


variable "shared_subscription_id" {}

#  variable "appsrv_settings" {
#    type = map(string)
#  }

# variable "app_settings_authserver" {
#   type = map(string)
# }

variable "vnet_route_all_enabled" {
  default = true
}

# variable "vnet_route_all_enabled_authserver" {
#   default = true
# }

variable "servicebus_name" {}
variable "servicebus_sku_type" {
  default = "Standard"
}

variable "app_config_name" {}
variable "app_config_sku_type" {
  default = "standard"
}

variable "log_analytics_workspace_name" {}
variable "log_analytics_sku" {
  default = "PerGB2018"
}
variable "log_analytics_retention_in_days" {
  default = 30
}
variable "log_analytics_daily_quota_in_gb" {
  default = 50
}
variable "log_analytics_internet_ingestion_enabled" {
  default = false
}
variable "log_analytics_internet_query_enabled" {
  default = false
}

#
# variable "sect_maps" {
#   type = map(string)
# }

# variable "sect_maps_authserver" {
#   type = map(string)
# }

#Redis Cache
variable "redis_CacheName" {}
variable "redis_sku_capacity" {}                    #2
variable "redis_sku_family" {}                      #"C"
variable "redis_sku_type" {}                        #"Standard"
variable "redis_enable_non_ssl_port" {}             #false
variable "redis_minimum_tls_version" {}             #"1.2"
variable "redis_public_network_access_enabled" {}   #false
variable "redis_config_maxmemory_reserved" {}       #2   #Default 50MB
variable "redis_maxfragmentationmemory_reserved" {} #12   #Default 50MB
variable "redis_maxmemory_policy" {}                #"volatile-lru"
variable "redis_version" {}
# variable "redis_patching_day" {}
# variable "redis_patching_time_in_utc" {}
variable "redis_patching_day" {
  default = "Null"
}
variable "redis_patching_time_in_utc" {
  default = "14"
}


#Redis EP
variable "pvtendpoint_redis_cache_name" {}
variable "pvtsrvconn_redis_cache_name" {}
variable "subresource_redis_cache" {
  type = list(string)
}

