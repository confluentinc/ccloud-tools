variable "gcp_availability_zones" {

  type = "list"

  default = ["us-east1-b", "us-east1-c"]

}

variable "instance_count" {

  type = "map"

  default = {

    "schema_registry"  =  1
    "rest_proxy"       =  1
    "kafka_connect"    =  1
    "ksql_server"      =  1
    "control_center"   =  1

  }

}

variable "confluent_platform_location" {

  default = "http://packages.confluent.io/archive/5.0/confluent-5.0.0-2.11.zip"

}