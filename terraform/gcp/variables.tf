variable "global_prefix" {
  default = "ccloud-tools"
}

variable "gcp_region" {
  default = "us-east1"
}

variable "gcp_availability_zones" {
  type = list(string)

  default = ["us-east1-b", "us-east1-c", "us-east1-d"]
}

variable "instance_count" {
  type = map(string)

  default = {
    "rest_proxy"     = 1
    "kafka_connect"  = 1
    "ksql_server"    = 1
    "control_center" = 1
  }
}

variable "confluent_platform_location" {
  default = "http://packages.confluent.io/archive/5.3/confluent-5.3.1-2.12.zip"
}

variable "confluent_home_value" {
  default = "/etc/confluent/confluent-5.3.1"
}

