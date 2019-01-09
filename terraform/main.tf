provider "azurerm" {
  version = "=1.20.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}"
  location = "${var.resource_group_location}"
}
