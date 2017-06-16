resource "azurerm_resource_group" "modSSRG" {
  name     = "${var.StudentId}-rgVMSS${var.azure_region}"
  location = "${var.azure_region}"
}

resource "azurerm_public_ip" "pipSSLB" {
  name                         = "${var.StudentId}-pipSSLB"
  location                     = "${var.azure_region}"
  resource_group_name          = "${azurerm_resource_group.modSSRG.name}"
  public_ip_address_allocation = "static"

  tags {
    ServerRole = "${var.server_role}"
  }
}

resource "azurerm_lb" "lbSS" {
  name                = "${var.StudentId}-lbSS"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.modSSRG.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.pipSSLB.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${azurerm_resource_group.modSSRG.name}"
  loadbalancer_id     = "${azurerm_lb.lbSS.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lbProbe" {
  resource_group_name = "${azurerm_resource_group.modSSRG.name}"
  loadbalancer_id     = "${azurerm_lb.lbSS.id}"
  name                = "http-probe"
  port                = 8081
}

resource "azurerm_lb_rule" "test" {
  resource_group_name            = "${azurerm_resource_group.modSSRG.name}"
  loadbalancer_id                = "${azurerm_lb.lbSS.id}"
  name                           = "TFLab-HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8081
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = "${azurerm_lb_probe.lbProbe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.bpepool.id}"
}

resource "azurerm_virtual_machine_scale_set" "modSS" {
  name                = "${var.StudentId}vmsstfhol"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.modSSRG.name}"
  upgrade_policy_mode = "Automatic"

  sku {
    name     = "Standard_A0"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "${var.publisher}"
    offer     = "${var.offer}"
    sku       = "${var.sku}"
    version   = "${var.version}"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix  = "${var.computer_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "HoLIPConf"
      subnet_id                              = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
    }
  }

  extension {
    name = "customScript"
    publisher = "Microsoft.OSTCExtensions"
    type = "CustomScriptForLinux"
    type_handler_version = "1.2"

    settings = <<SETTINGS
      {
        "fileUris": ["https://raw.githubusercontent.com/ianalderman/HOLAzureTerraformAnsible/master/scripts/provsvr.sh"],
        "commandToExecute": "bash provsvr.sh"
    }
SETTINGS
  }

  tags {
    ServerRole = "${var.server_role}"
  }
}