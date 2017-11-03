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
variable accountid {
  description = "IBM Cloud Account ID"
}
variable orgid {
  description = "IBM Cloud CloudFundry Organization ID"
}
variable spaceid {
  description = "IBM Cloud CloudFoundry Space ID"
}
variable clusterid {
  description = "IBM Cloud Container Service Cluster ID"
}
variable clusternamespace{
  description = "IBM Cloud Container Service Cluster namespace to bind the service instances to"
  default = "default"
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
# Resources
##############################################################################
resource "ibm_service_instance" "cloudant" {
  name       = "cloudant-created-with-schematics"
  space_guid = "${var.spaceid}"
  service    = "cloudantNoSQLDB"
  plan       = "Lite"
}

resource "ibm_container_bind_service" "cloudant_binding" {
  cluster_name_id             = "${var.clusterid}"
  service_instance_space_guid = "${var.spaceid}"
  service_instance_name_id    = "${ibm_service_instance.cloudant.id}"
  namespace_id                = "${var.clusternamespace}"
  account_guid                = "${var.accountid}"
  org_guid                    = "${var.orgid}"
  space_guid                  = "${var.spaceid}"
}

