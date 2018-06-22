resource "azurerm_resource_group" "concourse" {
  name     = "${var.env_id}-concourse"
  location = "${var.region}"

  tags {
    environment = "${var.env_id}"
  }
}

resource "azurerm_public_ip" "concourse" {
  name                         = "${var.env_id}-concourse"
  location                     = "${var.region}"
  resource_group_name          = "${azurerm_resource_group.concourse.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "${var.env_id}"
  }
}