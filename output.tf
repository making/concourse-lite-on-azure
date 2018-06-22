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