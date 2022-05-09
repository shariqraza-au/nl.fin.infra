variable "location_name" {}
variable "pvt_endpoint_name" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "pvtsrvconn_name" {}
variable "private_connection_resource_id" {}
variable "subresource_names" {
  type = list(string)
}
variable "private_dns_zone_ids" {}
