variable "cosmosdb_name" {}
variable "location_name" {}
variable "resource_group_name" {}
variable "offer_type" {}
# variable "public_network_access" {
#     type    = bool
#     default = false
# }
variable "app_subnetid" {}
variable "mmsg_ip_allow" {}
variable "tags" {
    type    = map
}
