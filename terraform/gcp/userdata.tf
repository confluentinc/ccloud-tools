###########################################
######### REST Proxy Bootstrap ############
###########################################

data "template_file" "rest_proxy_properties" {
  template = file("../util/rest-proxy.properties")

  vars = {
    global_prefix              = var.global_prefix
    bootstrap_server           = var.bootstrap_server
    cluster_api_key            = var.cluster_api_key
    cluster_api_secret         = var.cluster_api_secret
    confluent_home_value       = var.confluent_home_value
    schema_registry_url        = var.schema_registry_url
    schema_registry_basic_auth = var.schema_registry_basic_auth
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
    bootstrap_server           = var.bootstrap_server
    cluster_api_key            = var.cluster_api_key
    cluster_api_secret         = var.cluster_api_secret
    confluent_home_value       = var.confluent_home_value
    schema_registry_url        = var.schema_registry_url
    schema_registry_basic_auth = var.schema_registry_basic_auth
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
    bootstrap_server           = var.bootstrap_server
    cluster_api_key            = var.cluster_api_key
    cluster_api_secret         = var.cluster_api_secret
    confluent_home_value       = var.confluent_home_value
    schema_registry_url        = var.schema_registry_url
    schema_registry_basic_auth = var.schema_registry_basic_auth
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
    bootstrap_server           = var.bootstrap_server
    cluster_api_key            = var.cluster_api_key
    cluster_api_secret         = var.cluster_api_secret
    confluent_home_value       = var.confluent_home_value
    schema_registry_url        = var.schema_registry_url
    schema_registry_basic_auth = var.schema_registry_basic_auth
    kafka_connect_url          = "http://${google_compute_global_address.kafka_connect[0].address}"
    ksql_server_url            = "http://${google_compute_global_address.ksql_server[0].address}:80"
    ksql_public_url            = "http://${google_compute_global_address.ksql_server[0].address}:80"
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

