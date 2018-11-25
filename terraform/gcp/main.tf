###########################################
################## GCP ####################
###########################################

provider "google" {

    credentials = "${file(var.gcp_credentials)}"
    project = "${var.gcp_project}"
    region = "${var.gcp_region}"
  
}

variable "gcp_credentials" {}

variable "gcp_project" {}

variable "gcp_region" {}

###########################################
############# Confluent Cloud #############
###########################################

variable "ccloud_broker_list" {}

variable "ccloud_access_key" {}

variable "ccloud_secret_key" {}