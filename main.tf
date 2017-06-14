
# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "lab_network" {
  source = "modules/network"
  StudentId = ${vars.StudentId}
  azure_region = ${vars.azure_region}
}

