resource "azurerm_resource_group" "modNetworkRG" {
    name = "${var.StudentId}-rgNetwork"
    location = "${var.azure_region}"
}

resource "azurerm_virtual_network" "modNetworkVNet" {
    name = "${var.StudentId}-vnTFLab"
    address_space = ["10.${var.StudentId}.0.0/16"]
    location = "${var.azure_region}"
    resource_group_name = "${azurerm_resource_group.modNetworkRG.name}"
}

resource "azurerm_subnet" "modNetworkAppSubnet" {
    name = "${var.StudentId}-snApp"
    resource_group_name = "${azurerm_resource_group.modNetworkRG.name}"
    virtual_network_name = "${azurerm_virtual_network.modNetworkVNet.name}"
    address_prefix = "10.${var.StudentId}.1.0/24"
}

resource "azurerm_subnet" "modNetworkMgmtSubnet" {
    name = "${var.StudentId}-snMgmt"
    resource_group_name = "${azurerm_resource_group.modNetworkRG.name}"
    virtual_network_name = "${azurerm_virtual_network.modNetworkVNet.name}"
    address_prefix = "10.${var.StudentId}.0.0/24"
}

output "snManagementId" {
    value = "${azurerm_subnet.modNetworkMgmtSubnet.id}"
}

output "snApplicationId" {
    value = "${azurerm_subnet.modNetworkAppSubnet.id}"
}