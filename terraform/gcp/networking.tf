###########################################
################### VPC ###################
###########################################
resource "google_compute_network" "default" {

  name = "ccloud-tools"
  auto_create_subnetworks = false

}

###########################################
################# Subnets #################
###########################################

resource "google_compute_subnetwork" "private_subnet" {

  name = "private-subnet"
  project = "${var.gcp_project}"
  region = "${var.gcp_region}"
  network = "${google_compute_network.default.id}"
  ip_cidr_range = "10.0.1.0/24"

}

resource "google_compute_subnetwork" "public_subnet" {

  name = "public-subnet"
  project = "${var.gcp_project}"
  region = "${var.gcp_region}"
  network = "${google_compute_network.default.id}"
  ip_cidr_range = "10.0.2.0/24"

}

###########################################
############ Compute Firewalls ############
###########################################

resource "google_compute_firewall" "schema_registry" {

  name = "schema-registry"
  network = "${google_compute_network.default.name}"

  allow {

    protocol = "tcp"
    ports = ["22", "8081"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["schema-registry"]

}

resource "google_compute_firewall" "rest_proxy" {

  name = "rest-proxy"
  network = "${google_compute_network.default.name}"

  allow {

    protocol = "tcp"
    ports = ["22", "8082"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["rest-proxy"]

}

resource "google_compute_firewall" "kafka_connect" {

  name = "kafka-connect"
  network = "${google_compute_network.default.name}"

  allow {

    protocol = "tcp"
    ports = ["22", "8083"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["kafka-connect"]

}

resource "google_compute_firewall" "ksql_server" {

  name = "ksql-server"
  network = "${google_compute_network.default.name}"

  allow {

    protocol = "tcp"
    ports = ["22", "8088"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ksql-server"]

}

resource "google_compute_firewall" "control_center" {

  name = "control-center"
  network = "${google_compute_network.default.name}"

  allow {

    protocol = "tcp"
    ports = ["22", "9021"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["control-center"]

}