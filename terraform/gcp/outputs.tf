###########################################
################# Outputs #################
###########################################

output "REST_Proxy" {
  value = var.instance_count["rest_proxy"] >= 1 ? join(
    ",",
    formatlist(
      "http://%s",
      google_compute_global_address.rest_proxy.*.address,
    ),
  ) : "REST Proxy has been disabled"
}

output "Kafka_Connect" {
  value = var.instance_count["kafka_connect"] >= 1 ? join(
    ",",
    formatlist(
      "http://%s",
      google_compute_global_address.kafka_connect.*.address,
    ),
  ) : "Kafka Connect has been disabled"
}

output "KSQL_Server" {
  value = var.instance_count["ksql_server"] >= 1 ? join(
    ",",
    formatlist(
      "http://%s",
      google_compute_global_address.ksql_server.*.address,
    ),
  ) : "KSQL Server has been disabled"
}

output "Control_Center" {
  value = var.instance_count["control_center"] >= 1 ? join(
    ",",
    formatlist(
      "http://%s",
      google_compute_global_address.control_center.*.address,
    ),
  ) : "Control Center has been disabled"
}