resource "azurerm_network_security_group" "concourse" {
  name                = "${var.env_id}-concourse"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.concourse.name}"

  tags {
    environment = "${var.env_id}"
  }
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "${var.env_id}-ssh"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}

resource "azurerm_network_security_rule" "http" {
  name                        = "${var.env_id}-http"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}

resource "azurerm_network_security_rule" "https" {
  name                        = "${var.env_id}-https"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}

resource "azurerm_network_security_rule" "http8080" {
  name                        = "${var.env_id}-http8080"
  priority                    = 203
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}

resource "azurerm_network_security_rule" "https4443" {
  name                        = "${var.env_id}-https4443"
  priority                    = 204
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "4443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}

resource "azurerm_network_security_rule" "prometheus" {
  name                        = "${var.env_id}-prometheus"
  priority                    = 205
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9391"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}

resource "azurerm_network_security_rule" "mbus" {
  name                        = "${var.env_id}-mbus"
  priority                    = 206
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6868"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.concourse.name}"
  network_security_group_name = "${azurerm_network_security_group.concourse.name}"
}