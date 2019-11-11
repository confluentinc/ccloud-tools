data "template_file" "config_properties" {
  template = file("../util/config.properties")

  vars = {
    broker_list                = var.bootstrap_server
    access_key                 = var.cluster_api_key
    secret_key                 = var.cluster_api_secret
    schema_registry_url        = var.schema_registry_url
    schema_registry_basic_auth = var.schema_registry_basic_auth
  }
}

resource "null_resource" "local_config" {
  provisioner "local-exec" {
    command     = "rm ~/.ccloud/config"
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }

  provisioner "local-exec" {
    command     = "echo '${data.template_file.config_properties.rendered}' >> ~/.ccloud/config"
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }
}

