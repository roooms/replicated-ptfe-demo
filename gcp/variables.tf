variable "region" {
  description = "GCP region"
}

variable "project" {
  description = "GCP project name"
}

variable "namespace" {
  description = "Unique name to use for DNS and resource naming"
}

variable "active_ptfe_instance" {
  description = "The active PTFE instance eg ptfe1"
  default     = "ptfe1"
}

variable "active_alias_ip" {
  description = "Alias IP attached to the active PTFE instance"
}

variable "standby_alias_ip" {
  description = "Alias IP attached to the standby PTFE instance"
}

variable "gcp_machine_image" {
  description = "GCP machine image"
}

variable "gcp_machine_type" {
  description = "GCP machine type"
}

variable "ssh_public_key_file" {
  description = "Path to SSH public key file eg /home/user/.ssh/id_rsa.pub"
}

variable "owner" {
  description = "GCP instance owner"
}

variable "ttl" {
  description = "GCP instance TTL"
  default     = "168"
}
