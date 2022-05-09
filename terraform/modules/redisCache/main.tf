# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redisCache" {
  name                          = var.redis_CacheName
  location                      = var.location_name
  resource_group_name           = var.resource_group_name
  capacity                      = var.redis_sku_capacity                  #2
  family                        = var.redis_sku_family                    #"C"
  sku_name                      = var.redis_sku_type                      #"Standard"
  enable_non_ssl_port           = var.redis_enable_non_ssl_port           #false
  minimum_tls_version           = var.redis_minimum_tls_version           #"1.2"
  public_network_access_enabled = var.redis_public_network_access_enabled #false
  redis_version                 = var.redis_version

  # patch_schedule {
  #     day_of_week = var.redis_patching_day
  #     start_hour_utc = var.redis_patching_time_in_utc
  # }
  dynamic "patch_schedule" {
    for_each = var.redis_patching_day != "Null" ? [1] : []
    content {
      day_of_week    = var.redis_patching_day
      start_hour_utc = var.redis_patching_time_in_utc
    }
  }

  redis_configuration {
    maxmemory_reserved              = var.redis_config_maxmemory_reserved       #2   #Default 50MB
    maxfragmentationmemory_reserved = var.redis_maxfragmentationmemory_reserved #12   #Default 50MB
    maxmemory_policy                = var.redis_maxmemory_policy                #"volatile-lru"

  }

  tags = var.tags
}