variable "app_service_name" {}
variable "location_name" {}
variable "resource_group_name" {}
variable "app_service_plan_id" {}
variable "setting_APPINSIGHTS_INSTRUMENTATIONKEY" {}
variable "setting_VaultUri" {}
variable "setting_APPLICATIONINSIGHTS_CONNECTION_STRING" {}
# variable "setting_EventHubName" {}
# variable "setting_EventHubConnectionString" {}
variable "tags" {
  type = map(any)
}
# variable "appsrv_settings" {
#   type = map(string)
# }
# variable "vnet_route_all_enabled" {
#   default = true
# }
