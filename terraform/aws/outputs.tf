###########################################
################# Outputs #################
###########################################

output "schema_registry_endpoint" {

  value = "http://${aws_alb.schema_registry.0.dns_name}"

}

output "rest_proxy_endpoint" {

  value = "${var.instance_count["rest_proxy"] >= 1
           ? "${join(",", formatlist("http://%s", aws_alb.rest_proxy.*.dns_name))}"
           : "REST Proxy has been disabled"}"

}

output "kafka_connect_endpoint" {

  value = "${var.instance_count["kafka_connect"] >= 1
           ? "${join(",", formatlist("http://%s", aws_alb.kafka_connect.*.dns_name))}"
           : "Kafka Connect has been disabled"}"

}

output "ksql_server_endpoint" {

  value = "${var.instance_count["ksql_server"] >= 1
           ? "${join(",", formatlist("http://%s", aws_alb.ksql_server.*.dns_name))}"
           : "KSQL Server has been disabled"}"

}

output "control_center_endpoint" {

  value = "${var.instance_count["control_center"] >= 1
           ? "${join(",", formatlist("http://%s", aws_alb.control_center.*.dns_name))}"
           : "Control Center has been disabled"}"

}