###########################################
############# REST Proxy LBR ##############
###########################################

resource "google_compute_global_address" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name = "rest-proxy-global-address-${var.global_prefix}"
}

resource "google_compute_global_forwarding_rule" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name       = "rest-proxy-global-forwarding-rule-${var.global_prefix}"
  target     = google_compute_target_http_proxy.rest_proxy[0].self_link
  ip_address = google_compute_global_address.rest_proxy[0].self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name    = "rest-proxy-http-proxy-${var.global_prefix}"
  url_map = google_compute_url_map.rest_proxy[0].self_link
}

resource "google_compute_url_map" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name            = "rest-proxy-url-map-${var.global_prefix}"
  default_service = google_compute_backend_service.rest_proxy[0].self_link
}

resource "google_compute_backend_service" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name        = "rest-proxy-backend-service-${var.global_prefix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 5

  backend {
    group = google_compute_region_instance_group_manager.rest_proxy[0].instance_group
  }

  health_checks = [google_compute_http_health_check.rest_proxy[0].self_link]
}

resource "google_compute_region_instance_group_manager" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name                      = "rest-proxy-instance-group-${var.global_prefix}"
  base_instance_name        = "${var.global_prefix}-rest-proxy"
  region                    = local.region
  distribution_policy_zones = data.google_compute_zones.available.names
  target_size               = var.instance_count["rest_proxy"]

  version {
    instance_template = google_compute_instance_template.rest_proxy[0].self_link
  }

  named_port {
    name = "http"
    port = 8082
  }
}

resource "google_compute_http_health_check" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name                = "rest-proxy-http-health-check-${var.global_prefix}"
  request_path        = "/"
  port                = "8082"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  check_interval_sec  = 5
  timeout_sec         = 3
}

resource "google_compute_instance_template" "rest_proxy" {
  count = var.instance_count["rest_proxy"] > 0 ? var.instance_count["rest_proxy"] : 0

  name         = "rest-proxy-template-${var.global_prefix}"
  machine_type = "n1-standard-2"

  metadata_startup_script = data.template_file.rest_proxy_bootstrap.rendered

  disk {
    source_image = "centos-7"
    disk_size_gb = 100
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.self_link

    access_config {
    }
  }

  tags = ["rest-proxy-${var.global_prefix}"]
}

###########################################
########### Kafka Connect LBR #############
###########################################

resource "google_compute_global_address" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name = "kafka-connect-global-address-${var.global_prefix}"
}

resource "google_compute_global_forwarding_rule" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name       = "kafka-connect-global-forwarding-rule-${var.global_prefix}"
  target     = google_compute_target_http_proxy.kafka_connect[0].self_link
  ip_address = google_compute_global_address.kafka_connect[0].self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name    = "kafka-connect-http-proxy-${var.global_prefix}"
  url_map = google_compute_url_map.kafka_connect[0].self_link
}

resource "google_compute_url_map" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name            = "kafka-connect-url-map-${var.global_prefix}"
  default_service = google_compute_backend_service.kafka_connect[0].self_link
}

resource "google_compute_backend_service" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name        = "kafka-connect-backend-service-${var.global_prefix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 5

  backend {
    group = google_compute_region_instance_group_manager.kafka_connect[0].instance_group
  }

  health_checks = [google_compute_http_health_check.kafka_connect[0].self_link]
}

resource "google_compute_region_instance_group_manager" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name                      = "kafka-connect-instance-group-${var.global_prefix}"
  base_instance_name        = "${var.global_prefix}-kafka-connect"
  region                    = local.region
  distribution_policy_zones = data.google_compute_zones.available.names
  target_size               = var.instance_count["kafka_connect"]

  version {
    instance_template = google_compute_instance_template.kafka_connect[0].self_link
  }

  named_port {
    name = "http"
    port = 8083
  }
}

resource "google_compute_http_health_check" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name                = "kafka-connect-http-health-check-${var.global_prefix}"
  request_path        = "/"
  port                = "8083"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  check_interval_sec  = 5
  timeout_sec         = 3
}

resource "google_compute_instance_template" "kafka_connect" {
  count = var.instance_count["kafka_connect"] > 0 ? var.instance_count["kafka_connect"] : 0

  name         = "kafka-connect-template-${var.global_prefix}"
  machine_type = "n1-standard-2"

  metadata_startup_script = data.template_file.kafka_connect_bootstrap.rendered

  disk {
    source_image = "centos-7"
    disk_size_gb = 100
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.self_link

    access_config {
    }
  }

  tags = ["kafka-connect-${var.global_prefix}"]
}

###########################################
############ KSQL Server LBR ##############
###########################################

resource "google_compute_global_address" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name = "ksql-server-global-address-${var.global_prefix}"
}

resource "google_compute_global_forwarding_rule" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name       = "ksql-server-global-forwarding-rule-${var.global_prefix}"
  target     = google_compute_target_http_proxy.ksql_server[0].self_link
  ip_address = google_compute_global_address.ksql_server[0].self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name    = "ksql-server-http-proxy-${var.global_prefix}"
  url_map = google_compute_url_map.ksql_server[0].self_link
}

resource "google_compute_url_map" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name            = "ksql-server-url-map-${var.global_prefix}"
  default_service = google_compute_backend_service.ksql_server[0].self_link
}

resource "google_compute_backend_service" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name        = "ksql-server-backend-service-${var.global_prefix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 5

  backend {
    group = google_compute_region_instance_group_manager.ksql_server[0].instance_group
  }

  health_checks = [google_compute_http_health_check.ksql_server[0].self_link]
}

resource "google_compute_region_instance_group_manager" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name                      = "ksql-server-instance-group-${var.global_prefix}"
  base_instance_name        = "${var.global_prefix}-ksql-server"
  region                    = local.region
  distribution_policy_zones = data.google_compute_zones.available.names
  target_size               = var.instance_count["ksql_server"]

  version {
    instance_template = google_compute_instance_template.ksql_server[0].self_link
  }

  named_port {
    name = "http"
    port = 8088
  }
}

resource "google_compute_http_health_check" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name                = "ksql-server-http-health-check-${var.global_prefix}"
  request_path        = "/info"
  port                = "8088"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  check_interval_sec  = 5
  timeout_sec         = 3
}

resource "google_compute_instance_template" "ksql_server" {
  count = var.instance_count["ksql_server"] > 0 ? var.instance_count["ksql_server"] : 0

  name         = "ksql-server-template-${var.global_prefix}"
  machine_type = "n1-standard-8"

  metadata_startup_script = data.template_file.ksql_server_bootstrap.rendered

  disk {
    source_image = "centos-7"
    disk_size_gb = 300
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.self_link

    access_config {
    }
  }

  tags = ["ksql-server-${var.global_prefix}"]
}

###########################################
########### Control Center LBR ############
###########################################

resource "google_compute_global_address" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name = "control-center-global-address-${var.global_prefix}"
}

resource "google_compute_global_forwarding_rule" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name       = "control-center-global-forwarding-rule-${var.global_prefix}"
  target     = google_compute_target_http_proxy.control_center[0].self_link
  ip_address = google_compute_global_address.control_center[0].self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name    = "control-center-http-proxy-${var.global_prefix}"
  url_map = google_compute_url_map.control_center[0].self_link
}

resource "google_compute_url_map" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name            = "control-center-url-map-${var.global_prefix}"
  default_service = google_compute_backend_service.control_center[0].self_link
}

resource "google_compute_backend_service" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name        = "control-center-backend-service-${var.global_prefix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 5

  backend {
    group = google_compute_region_instance_group_manager.control_center[0].instance_group
  }

  health_checks = [google_compute_http_health_check.control_center[0].self_link]
}

resource "google_compute_region_instance_group_manager" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name                      = "control-center-instance-group-${var.global_prefix}"
  base_instance_name        = "${var.global_prefix}-control-center"
  region                    = local.region
  distribution_policy_zones = data.google_compute_zones.available.names
  target_size               = var.instance_count["control_center"]

  version {
    instance_template = google_compute_instance_template.control_center[0].self_link
  }

  named_port {
    name = "http"
    port = 9021
  }
}

resource "google_compute_http_health_check" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name                = "control-center-http-health-check-${var.global_prefix}"
  request_path        = "/"
  port                = "9021"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  check_interval_sec  = 5
  timeout_sec         = 3
}

resource "google_compute_instance_template" "control_center" {
  count = var.instance_count["control_center"] > 0 ? var.instance_count["control_center"] : 0

  name         = "control-center-template-${var.global_prefix}"
  machine_type = "n1-standard-8"

  metadata_startup_script = data.template_file.control_center_bootstrap.rendered

  disk {
    source_image = "centos-7"
    disk_size_gb = 300
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.self_link

    access_config {
    }
  }

  tags = ["control-center-${var.global_prefix}"]
}

