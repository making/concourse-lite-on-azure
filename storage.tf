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