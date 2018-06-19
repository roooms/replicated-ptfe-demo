#------------------------------------------------------------------------------
# production external-services ptfe resources
#------------------------------------------------------------------------------

locals {
  namespace = "${var.namespace}-pes"
}

resource "google_compute_instance" "default" {
  count        = 2
  name         = "${local.namespace}-instance-${count.index+1}"
  machine_type = "${var.gcp_machine_type}"
  zone         = "${element(var.zone, count.index)}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_machine_image}"
    }
  }

  // Local SSD disk
  scratch_disk {}

  network_interface {
    subnetwork = "${element(var.subnetwork, count.index)}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"
}
