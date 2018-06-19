output "available_zones" {
  value = "${data.google_compute_zones.main.names}"
}

output "public_subnet_ids" {
  value = "${google_compute_subnetwork.public.*.id}"
}

output "private_subnet_ids" {
  value = "${google_compute_subnetwork.private.*.id}"
}
