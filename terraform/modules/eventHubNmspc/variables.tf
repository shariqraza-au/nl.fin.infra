variable "namespace_name" {}
variable "location_name" {}
variable "resource_group_name" {}
variable "namespace_sku" {}
variable "namespace_capacity" {}
variable "eventHub_name" {}
variable "message_retention" {}

variable "app_subnetid" {}
variable "pvt_ep_subnet_address" {}
variable "tags" {
    type    = map
}
