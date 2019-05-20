variable "global_prefix" {

  default = "ccloud-tools"

}

variable "aws_region" {

}

variable "aws_availability_zones" {

  type = "list"

}

variable "ec2_ami" {

}

variable "instance_count" {

  type = "map"

  default = {

    "rest_proxy"       =  0
    "kafka_connect"    =  0
    "ksql_server"      =  1
    "control_center"   =  1
    "bastion_server"   =  1

  }

}

variable "confluent_platform_location" {

  default = "http://packages.confluent.io/archive/5.2/confluent-5.2.1-2.12.zip"

}

variable "confluent_home_value" {

  default = "/etc/confluent/confluent-5.2.1"

}