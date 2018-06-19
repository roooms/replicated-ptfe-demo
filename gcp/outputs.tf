output "available_zones" {
  value = "${module.network.available_zones}"
}

output "public_subnet_ids" {
  value = "${module.network.public_subnet_ids}"
}

output "private_subnet_ids" {
  value = "${module.network.private_subnet_ids}"
}
