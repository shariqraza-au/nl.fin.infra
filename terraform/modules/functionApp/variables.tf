variable "azfunc_name" {}
variable "location_name" {}
variable "resource_group_name" {}
variable "app_service_plan_id" {}
variable "storage_account_name" {}
variable "storage_account_access_key" {}
variable "setting_AzureWebJobsStorage" {}
variable "setting_APPINSIGHTS_INSTRUMENTATIONKEY" {}
variable "setting_VaultUri" {}
variable "setting_APPLICATIONINSIGHTS_CONNECTION_STRING" {}
# variable "setting_EventHubConnectionString" {}
# variable "setting_EventHubName" {}
variable "tags" {
    type    = map
}
