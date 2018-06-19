variable "namespace" {}
variable "gcp_machine_image" {}
variable "gcp_machine_type" {}
variable "region" {}

variable "zone" {
  type = "list"
}

variable "subnetwork" {
  type = "list"
}

variable "owner" {}
variable "ttl" {}
