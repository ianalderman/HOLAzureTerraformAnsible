terraform {
  backend "azure" {
    storage_account_name = "<STUDENT ID>satflabstateinfra"
    container_name       = "dev-tfstate"
    key                  = "dev.terraform.tfstate"
  }
}