variable "redis_CacheName" {}
variable "location_name" {}
variable "resource_group_name" {}
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
variable "redis_patching_day" {
  default = "Null"
}
variable "redis_patching_time_in_utc" {
  default = "14"
}
variable "tags" {
  type = map(any)
}