variable "location_name" {}
variable "resource_group_name" {}


variable "appInsight_name" {}
variable "tags" {
  type = map(any)
}
variable "log_analytics_workspace_name" {}
variable "log_analytics_sku" {}
variable "log_analytics_retention_in_days" {}
variable "log_analytics_daily_quota_in_gb" {}
variable "log_analytics_internet_ingestion_enabled" {}
variable "log_analytics_internet_query_enabled" {}