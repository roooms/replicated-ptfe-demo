variable "namespace" {}
variable "region" {}

variable "zone" {
  type = "list"
}

variable "gcp_machine_image" {}
variable "gcp_machine_type" {}
variable "subnetwork" {}
variable "owner" {}
variable "ttl" {}

variable "active_ptfe_instance" {}
variable "active_alias_ip" {}
variable "standby_alias_ip" {}
