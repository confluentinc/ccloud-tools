###########################################
######## Schema Registry Bootstrap ########
###########################################

data "template_file" "schema_registry_properties" {

  template = "${file("../util/schema-registry.properties")}"

  vars {

    broker_list = "${var.ccloud_broker_list}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}

data "template_file" "schema_registry_bootstrap" {

  template = "${file("../util/schema-registry.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    schema_registry_properties = "${data.template_file.schema_registry_properties.rendered}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}

###########################################
######### REST Proxy Bootstrap ############
###########################################

data "template_file" "rest_proxy_properties" {

  template = "${file("../util/rest-proxy.properties")}"

  vars {

    broker_list = "${var.ccloud_broker_list}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"
    confluent_home_value = "${var.confluent_home_value}"

    schema_registry_url = "http://${google_compute_global_address.schema_registry.address}"

  }

}

data "template_file" "rest_proxy_bootstrap" {

  template = "${file("../util/rest-proxy.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    rest_proxy_properties = "${data.template_file.rest_proxy_properties.rendered}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}

###########################################
######## Kafka Connect Bootstrap ##########
###########################################

data "template_file" "kafka_connect_properties" {

  template = "${file("../util/kafka-connect.properties")}"

  vars {

    broker_list = "${var.ccloud_broker_list}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"
    confluent_home_value = "${var.confluent_home_value}"

    schema_registry_url = "http://${google_compute_global_address.schema_registry.address}"

  }

}

data "template_file" "kafka_connect_bootstrap" {

  template = "${file("../util/kafka-connect.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    kafka_connect_properties = "${data.template_file.kafka_connect_properties.rendered}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}

###########################################
######### KSQL Server Bootstrap ###########
###########################################

data "template_file" "ksql_server_properties" {

  template = "${file("../util/ksql-server.properties")}"

  vars {

    broker_list = "${var.ccloud_broker_list}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"
    confluent_home_value = "${var.confluent_home_value}"

    schema_registry_url = "http://${google_compute_global_address.schema_registry.address}"

  }

}

data "template_file" "ksql_server_bootstrap" {

  template = "${file("../util/ksql-server.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    ksql_server_properties = "${data.template_file.ksql_server_properties.rendered}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}

###########################################
######## Control Center Bootstrap #########
###########################################

data "template_file" "control_center_properties" {

  template = "${file("../util/control-center.properties")}"

  vars {

    broker_list = "${var.ccloud_broker_list}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"
    confluent_home_value = "${var.confluent_home_value}"

    schema_registry_url = "http://${google_compute_global_address.schema_registry.address}"

    kafka_connect_url = "http://${google_compute_global_address.kafka_connect.address}"

    ksql_server_url = "http://${google_compute_global_address.ksql_server.address}"

    ksql_public_url = "http://${google_compute_global_address.ksql_server.address}"

  }

}

data "template_file" "control_center_bootstrap" {

  template = "${file("../util/control-center.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    control_center_properties = "${data.template_file.control_center_properties.rendered}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}