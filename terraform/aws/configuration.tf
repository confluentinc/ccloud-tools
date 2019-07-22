data "template_file" "config_properties" {
  template = file("../util/config.properties")

  vars = {
    broker_list                = var.ccloud_broker_list
    access_key                 = var.ccloud_access_key
    secret_key                 = var.ccloud_secret_key
    schema_registry_url        = var.ccloud_schema_registry_url
    schema_registry_basic_auth = var.ccloud_schema_registry_basic_auth
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

