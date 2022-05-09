variable "storageAccount_name" {}
variable "resource_group_name" {}
variable "location_name" {}
variable "storageAccount_account_tier" {}
variable "account_replication_type" {}
variable "app_subnetid" {}
variable "mmsg_ip_allow" {
    type    = list(string)
}
variable "tags" {
    type    = map
}
