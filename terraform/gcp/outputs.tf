###########################################
################# Outputs #################
###########################################

output "Schema Registry" {

  value = "${join(",", formatlist("http://%s:%s", google_compute_instance.schema_registry.*.network_interface.0.access_config.0.assigned_nat_ip, "8081"))}"

}

output "REST Proxy" {

  value = "${var.instance_count["rest_proxy"] >= 1
           ? "${join(",", formatlist("http://%s:%s", google_compute_instance.rest_proxy.*.network_interface.0.access_config.0.assigned_nat_ip, "8082"))}"
           : "REST Proxy has been disabled"}"

}

output "Kafka Connect" {

  value = "${var.instance_count["kafka_connect"] >= 1
           ? "${join(",", formatlist("http://%s:%s", google_compute_instance.kafka_connect.*.network_interface.0.access_config.0.assigned_nat_ip, "8083"))}"
           : "Kafka Connect has been disabled"}"

}

output "KSQL Server" {

  value = "${var.instance_count["ksql_server"] >= 1
           ? "${join(",", formatlist("http://%s:%s", google_compute_instance.ksql_server.*.network_interface.0.access_config.0.assigned_nat_ip, "8088"))}"
           : "KSQL Server has been disabled"}"

}

output "Control Center" {

  value = "${var.instance_count["control_center"] >= 1
           ? "${join(",", formatlist("http://%s:%s", google_compute_instance.control_center.*.network_interface.0.access_config.0.assigned_nat_ip, "9021"))}"
           : "Control Center has been disabled"}"

}