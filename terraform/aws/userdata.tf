###########################################
######### REST Proxy Bootstrap ############
###########################################

data "template_file" "rest_proxy_properties" {
  template = file("../util/rest-proxy.properties")

  vars = {
    broker_list                = var.ccloud_broker_list
    access_key                 = var.ccloud_access_key
    secret_key                 = var.ccloud_secret_key
    schema_registry_url        = var.ccloud_schema_registry_url
    schema_registry_basic_auth = var.ccloud_schema_registry_basic_auth
    confluent_home_value       = var.confluent_home_value
  }
}

data "template_file" "rest_proxy_bootstrap" {
  template = file("../util/rest-proxy.sh")

  vars = {
    confluent_platform_location = var.confluent_platform_location
    rest_proxy_properties       = data.template_file.rest_proxy_properties.rendered
    confluent_home_value        = var.confluent_home_value
  }
}

###########################################
######## Kafka Connect Bootstrap ##########
###########################################

data "template_file" "kafka_connect_properties" {
  template = file("../util/kafka-connect.properties")

  vars = {
    global_prefix              = var.global_prefix
    broker_list                = var.ccloud_broker_list
    access_key                 = var.ccloud_access_key
    secret_key                 = var.ccloud_secret_key
    schema_registry_url        = var.ccloud_schema_registry_url
    schema_registry_basic_auth = var.ccloud_schema_registry_basic_auth
    confluent_home_value       = var.confluent_home_value
  }
}

data "template_file" "kafka_connect_bootstrap" {
  template = file("../util/kafka-connect.sh")

  vars = {
    confluent_platform_location = var.confluent_platform_location
    kafka_connect_properties    = data.template_file.kafka_connect_properties.rendered
    confluent_home_value        = var.confluent_home_value
  }
}

###########################################
######### KSQL Server Bootstrap ###########
###########################################

data "template_file" "ksql_server_properties" {
  template = file("../util/ksql-server.properties")

  vars = {
    global_prefix              = var.global_prefix
    broker_list                = var.ccloud_broker_list
    access_key                 = var.ccloud_access_key
    secret_key                 = var.ccloud_secret_key
    schema_registry_url        = var.ccloud_schema_registry_url
    schema_registry_basic_auth = var.ccloud_schema_registry_basic_auth
    confluent_home_value       = var.confluent_home_value
  }
}

data "template_file" "ksql_server_bootstrap" {
  template = file("../util/ksql-server.sh")

  vars = {
    confluent_platform_location = var.confluent_platform_location
    ksql_server_properties      = data.template_file.ksql_server_properties.rendered
    confluent_home_value        = var.confluent_home_value
  }
}

###########################################
######## Control Center Bootstrap #########
###########################################

data "template_file" "control_center_properties" {
  template = file("../util/control-center.properties")

  vars = {
    global_prefix              = var.global_prefix
    broker_list                = var.ccloud_broker_list
    access_key                 = var.ccloud_access_key
    secret_key                 = var.ccloud_secret_key
    schema_registry_url        = var.ccloud_schema_registry_url
    schema_registry_basic_auth = var.ccloud_schema_registry_basic_auth
    confluent_home_value       = var.confluent_home_value
    kafka_connect_url = join(
      ",",
      formatlist(
        "http://%s:%s",
        aws_instance.kafka_connect.*.private_ip,
        "8083",
      ),
    )
    ksql_server_url = join(
      ",",
      formatlist(
        "http://%s:%s",
        aws_instance.ksql_server.*.private_ip,
        "8088",
      ),
    )
    ksql_public_url = join(
      ",",
      formatlist("http://%s:%s", aws_alb.ksql_server.*.dns_name, "80"),
    )
  }
}

data "template_file" "control_center_bootstrap" {
  template = file("../util/control-center.sh")

  vars = {
    confluent_platform_location = var.confluent_platform_location
    control_center_properties   = data.template_file.control_center_properties.rendered
    confluent_home_value        = var.confluent_home_value
  }
}

###########################################
######## Bastion Server Bootstrap #########
###########################################

data "template_file" "bastion_server_bootstrap" {
  template = file("../util/bastion-server.sh")

  vars = {
    private_key_pem      = tls_private_key.key_pair.private_key_pem
    rest_proxy_addresses = join(" ", formatlist("%s", aws_instance.rest_proxy.*.private_ip))
    kafka_connect_addresses = join(
      " ",
      formatlist("%s", aws_instance.kafka_connect.*.private_ip),
    )
    ksql_server_addresses = join(" ", formatlist("%s", aws_instance.ksql_server.*.private_ip))
    control_center_addresses = join(
      " ",
      formatlist("%s", aws_instance.control_center.*.private_ip),
    )
  }
}

