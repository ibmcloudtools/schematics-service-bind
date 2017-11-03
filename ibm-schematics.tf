##############################################################################
# Require terraform 0.9.3 or greater
##############################################################################
terraform {
  required_version = ">= 0.9.3"
}

##############################################################################
# Variables
##############################################################################
variable bxapikey {
  description = "Your Bluemix API key."
}
variable slusername {
  description = "Your Bluemix Infrastructure (SoftLayer) user name."
}
variable slapikey {
  description = "Your Bluemix Infrastructure (SoftLayer) API key."
}

##############################################################################
# IBM Cloud Provider
##############################################################################
provider "ibm" {
  bluemix_api_key = "${var.bxapikey}"
  softlayer_username = "${var.slusername}"
  softlayer_api_key = "${var.slapikey}"
}

##############################################################################
# Data Sources
##############################################################################
data "ibm_container_cluster" "playground" {
  cluster_name_id = "devex-playground"
  org_guid        = "25a313d0-2842-479d-9597-9cca129222d2"
  space_guid      = "693c2fed-20b9-4ae3-aef8-f425759b77b8"
  account_guid    = "2de836702ef00a3435bab2a105c5452b"
}
##############################################################################
# Resources
##############################################################################
resource "ibm_service_instance" "cloudant" {
  name       = "cloudant-created-with-schematics"
  space_guid = "693c2fed-20b9-4ae3-aef8-f425759b77b8"
  service    = "cloudantNoSQLDB"
  plan       = "Lite"
}

resource "ibm_container_bind_service" "cloudant_binding" {
  cluster_name_id             = "${data.ibm_container_cluster.playground.id}"
  service_instance_space_guid = "693c2fed-20b9-4ae3-aef8-f425759b77b8"
  service_instance_name_id    = "${ibm_service_instance.cloudant.id}"
  namespace_id                = "default"
  org_guid                    = "25a313d0-2842-479d-9597-9cca129222d2"
  space_guid                  = "693c2fed-20b9-4ae3-aef8-f425759b77b8"
  account_guid                = "2de836702ef00a3435bab2a105c5452b"
}

##############################################################################
# Outputs
##############################################################################
output "cluster_id" {
  value = "${data.ibm_container_cluster.playground.id}"
}