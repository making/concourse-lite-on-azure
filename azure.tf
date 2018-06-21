variable "env_id" {}

variable "region" {}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "network_cidr" {
  default = "10.0.0.0/16"
}

variable "internal_cidr" {
  default = "10.0.0.0/16"
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

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

resource "random_string" "account" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_storage_account" "concourse" {
  name                = "${var.env_id}${random_string.account.result}"
  resource_group_name = "${azurerm_resource_group.concourse.name}"

  location                 = "${var.region}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags {
    environment = "${var.env_id}"
  }

  lifecycle {
    ignore_changes = ["name"]
  }
}

resource "azurerm_storage_container" "concourse" {
  name                  = "concourse"
  resource_group_name   = "${azurerm_resource_group.concourse.name}"
  storage_account_name  = "${azurerm_storage_account.concourse.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell" {
  name                  = "stemcell"
  resource_group_name   = "${azurerm_resource_group.concourse.name}"
  storage_account_name  = "${azurerm_storage_account.concourse.name}"
  container_access_type = "blob"
}

output "vnet_name" {
  value = "${azurerm_virtual_network.concourse.name}"
}

output "subnet_name" {
  value = "${azurerm_subnet.concourse.name}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.concourse.name}"
}

output "storage_account_name" {
  value = "${azurerm_storage_account.concourse.name}"
}

output "default_security_group" {
  value = "${azurerm_network_security_group.concourse.name}"
}

output "external_ip" {
  value = "${azurerm_public_ip.concourse.ip_address}"
}

output "network_cidr" {
  value = "${var.network_cidr}"
}

output "concourse_name" {
  value = "concourse-${var.env_id}"
}

output "internal_cidr" {
  value = "${var.internal_cidr}"
}

output "subnet_cidr" {
  value = "${cidrsubnet(var.network_cidr, 8, 0)}"
}

output "internal_gw" {
  value = "${cidrhost(var.internal_cidr, 1)}"
}

output "concourse_internal_ip" {
  value = "${cidrhost(var.internal_cidr, 6)}"
}

output "subscription_id" {
  value = "${var.subscription_id}"
}

output "tenant_id" {
  value = "${var.tenant_id}"
}

output "client_id" {
  value = "${var.client_id}"
}

output "client_secret" {
  value = "${var.client_secret}"
}