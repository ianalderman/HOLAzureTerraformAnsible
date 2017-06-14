terraform {
  backend "azure" {
    storage_account_name = "iasatflabstateinfra"
    container_name       = "dev-tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "modNetworkRG" {
    name = "${var.StudentId}-rgNetwork"
    location = "${var.azureregion}"
}

resource "azurerm_virtual_network" "modNetworkVNet" {
    name = "${var.StudentId}-vnTFLab"
    address_space = "10.${var.StudentId}.0.0/16"
    location = "${var.azureregion}"
    resource_group_name = "${azurerm_resource_group.modNetworkRG}"
}

resource "azurerm_subnet" "modNetworkAppSubnet" {
    name = "${var.StudentId}-snApp"
    resource_group_name = "${azurerm_resource_group.modNetworkRG}"
    virtual_network_name = "${azurerm_virtual_network.modNetworkVNet}"
    address_prefix = "10.${var.StudentId}.1.0/24"
}

resource "azurerm_subnet" "modNetworkMgmtSubnet" {
    name = "${var.StudentId}-snApp"
    resource_group_name = "${azurerm_resource_group.modNetworkRG}"
    virtual_network_name = "${azurerm_virtual_network.modNetworkVNet}"
    address_prefix = "10.${var.StudentId}.0.0/24"
}

output "snManagementId" {
    value = ${azurerm_subnet.modNetworkMgmtSubnet.Id}
}

output "snApplicationId" {
    value = ${azurerm_subnet.modNetworkAppSubnet.Id}
}