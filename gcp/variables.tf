variable "region" {
  description = "GCP region"
}

variable "project" {
  description = "GCP project name"
}

variable "namespace" {
  description = "Unique name to use for DNS and resource naming"
}

variable "gcp_machine_image" {
  description = "GCP machine image"
}

variable "gcp_machine_type" {
  description = "GCP machine type"
}

variable "owner" {
  description = "GCP instance owner"
}

variable "ttl" {
  description = "GCP instance TTL"
  default     = "168"
}
