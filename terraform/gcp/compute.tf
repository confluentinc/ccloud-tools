###########################################
############ Schema Registry ##############
###########################################

resource "google_compute_instance" "schema_registry" {

    depends_on = ["google_compute_subnetwork.private_subnet"]

    count = "${var.instance_count["schema_registry"] >= 1
           ? var.instance_count["schema_registry"] : 1}"

    name = "schema-registry-${count.index}"
    machine_type = "n1-standard-2"
    zone = "${element(var.gcp_availability_zones, count.index)}"

    metadata_startup_script = "${data.template_file.schema_registry_bootstrap.rendered}"

    boot_disk {

        initialize_params {

            image = "centos-7"
            size = 100

        }

    }    

    network_interface {

        subnetwork = "${google_compute_subnetwork.private_subnet.self_link}"

        access_config {
            # ephemeral external ip address
        }

    }

    tags = ["schema-registry"]

}

###########################################
############### REST Proxy ################
###########################################

resource "google_compute_instance" "rest_proxy" {

    depends_on = ["google_compute_instance.schema_registry"]

    count = "${var.instance_count["rest_proxy"]}"
    name = "rest-proxy-${count.index}"
    machine_type = "n1-standard-2"
    zone = "${element(var.gcp_availability_zones, count.index)}"

    metadata_startup_script = "${data.template_file.rest_proxy_bootstrap.rendered}"

    boot_disk {

        initialize_params {

            image = "centos-7"
            size = 100

        }

    }    

    network_interface {

        subnetwork = "${google_compute_subnetwork.private_subnet.self_link}"

        access_config {
            # ephemeral external ip address
        }

    }

    tags = ["rest-proxy"]

}

###########################################
############## Kafka Connect ##############
###########################################

resource "google_compute_instance" "kafka_connect" {

    depends_on = ["google_compute_instance.schema_registry"]

    count = "${var.instance_count["kafka_connect"]}"
    name = "kafka-connect-${count.index}"
    machine_type = "n1-standard-2"
    zone = "${element(var.gcp_availability_zones, count.index)}"

    metadata_startup_script = "${data.template_file.kafka_connect_bootstrap.rendered}"

    boot_disk {

        initialize_params {

            image = "centos-7"
            size = 100

        }

    }    

    network_interface {

        subnetwork = "${google_compute_subnetwork.private_subnet.self_link}"

        access_config {
            # ephemeral external ip address
        }

    }

    tags = ["kafka-connect"]

}

###########################################
############### KSQL Server ###############
###########################################

resource "google_compute_instance" "ksql_server" {

    depends_on = ["google_compute_instance.schema_registry"]

    count = "${var.instance_count["ksql_server"]}"
    name = "ksql-server-${count.index}"
    machine_type = "n1-standard-8"
    zone = "${element(var.gcp_availability_zones, count.index)}"

    metadata_startup_script = "${data.template_file.ksql_server_bootstrap.rendered}"

    boot_disk {

        initialize_params {

            image = "centos-7"
            size = 300

        }

    }    

    network_interface {

        subnetwork = "${google_compute_subnetwork.private_subnet.self_link}"

        access_config {
            # ephemeral external ip address
        }

    }

    tags = ["ksql-server"]

}

###########################################
############# Control Center ##############
###########################################

resource "google_compute_instance" "control_center" {

    depends_on = ["google_compute_instance.schema_registry"]

    count = "${var.instance_count["control_center"]}"
    name = "control-center-${count.index}"
    machine_type = "n1-standard-8"
    zone = "${element(var.gcp_availability_zones, count.index)}"

    metadata_startup_script = "${data.template_file.control_center_bootstrap.rendered}"

    boot_disk {

        initialize_params {

            image = "centos-7"
            size = 300

        }

    }    

    network_interface {

        subnetwork = "${google_compute_subnetwork.private_subnet.self_link}"

        access_config {
            # ephemeral external ip address
        }

    }

    tags = ["control-center"]

}