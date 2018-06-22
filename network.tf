resource "azurerm_virtual_network" "concourse" {
  name                = "${var.env_id}-concourse-vn"
  address_space       = ["${var.network_cidr}"]
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.concourse.name}"
}

resource "azurerm_subnet" "concourse" {
  name                 = "${var.env_id}-concourse-sn"
  address_prefix       = "${cidrsubnet(var.network_cidr, 8, 0)}"
  resource_group_name  = "${azurerm_resource_group.concourse.name}"
  virtual_network_name = "${azurerm_virtual_network.concourse.name}"
}