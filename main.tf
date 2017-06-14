terraform {
  backend "azure" {
    storage_account_name = "iasatflabstateinfra"
    container_name       = "dev-tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "lab_network" {
  source = "./modules/network"

  StudentId = "${var.StudentId}"
  azure_region = "${var.azure_region}"
}

module "lab_bastion" {
  source = "./modules/singlevm"

  StudentId = "${var.StudentId}"
  azure_region = "${var.azure_region}"
  server_role     = "Bastion"
  subnet_id       = "${module.lab_network.snManagementId}"
  vm_size         = "Standard_d2_v2"
  publisher       = "Canonical"
  offer           = "UbuntuServer"
  sku             = "14.04.2-LTS"
  version         = "latest"
  computer_name   = "vmBastion01"
  admin_username  = "tflabadm"
  admin_password  = "Passw0rd123!=="
}

module "lab_webscaleset" {
  source = "./modules/vmscaleset"

  StudentId = "${var.StudentId}"
  azure_region = "${var.azure_region}"
  server_role     = "WebServer"
  subnet_id       = "${module.lab_network.snApplicationId}"
  vm_size         = "Standard_d2_v2"
  publisher       = "Canonical"
  offer           = "UbuntuServer"
  sku             = "14.04.2-LTS"
  version         = "latest"
  computer_name   = "vmWebserver"
  admin_username  = "tflabadm"
  admin_password  = "Passw0rd123!=="
}
