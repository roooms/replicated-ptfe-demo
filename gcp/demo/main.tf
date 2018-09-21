#------------------------------------------------------------------------------
# production external-services ptfe resources
#------------------------------------------------------------------------------

locals {
  namespace = "${var.namespace}-demo"
}

resource "google_compute_instance" "ptfe" {
  name         = "${local.namespace}-instance-ptfe"
  machine_type = "${var.gcp_machine_type}"
  zone         = "${var.zone[0]}"

  boot_disk {
    initialize_params {
      size  = 100
      image = "${var.gcp_machine_image}"
    }
  }

  network_interface {
    access_config = {}
    subnetwork    = "${var.subnetwork}"
  }

  metadata_startup_script = "${var.startup_script}"

  service_account {
    scopes = ["https://www.googleapis.com/auth/sqlservice.admin"]
  }

  allow_stopping_for_update = true

   provisioner "local-exec" {
    command = " gcloud compute ssh --zone ${var.zone[0]} ${google_compute_instance.ptfe.name} --command 'sudo  /tmp/install_ptfe.sh no-proxy bypass-storagedriver-warnings '  "
  }


}
