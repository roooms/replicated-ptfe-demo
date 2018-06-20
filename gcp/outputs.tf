output "available_zones" {
  value = "${module.network.available_zones}"
}

output "private_subnet_id" {
  value = "${module.network.private_subnet_id}"
}

output "db_connection_name" {
  value = "${module.pes.db_connection_name}"
}
