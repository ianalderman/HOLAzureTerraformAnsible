resource "azurerm_resource_group" "modVMRG" {
    name = "${var.StudentId}-rgVM${var.azure_region}"
    location = "${var.azure_region}"
}

resource "azurerm_public_ip" "pipVM" {
  name                         = "${var.StudentId}-pipSingleVM"
  location                     = "${var.azure_region}"
  resource_group_name          = "${azurerm_resource_group.modVMRG.name}"
  public_ip_address_allocation = "static"

  tags {
    ServerRole = "${var.server_role}"
  }
}


resource "azurerm_network_interface" "nicVM" {
  name                = "vmnic"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.modVMRG.name}"

  ip_configuration {
    name                          = "niccfVM"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pipVM.id}"
  }
}

resource "azurerm_virtual_machine" "asVM" {
  name                  = "vm${var.server_role}"
  location              = "${var.azure_region}"
  resource_group_name   = "${azurerm_resource_group.modVMRG.name}"
  network_interface_ids = ["${azurerm_network_interface.nicVM.id}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "${var.publisher}"
    offer     = "${var.offer}"
    sku       = "${var.sku}"
    version   = "${var.version}"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.computer_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    ServerRole = "${var.server_role}"
  }
}