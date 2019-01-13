provider "azurerm" {
  version = "=1.20.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}"
  location = "${var.resource_group_location}"
}

resource "azurerm_application_insights" "ai" {
  name                = "${var.ai_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  application_type    = "Web"
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.cosmos_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = "${azurerm_resource_group.rg.location}"
    failover_priority = 0
  }
}

# todo: bring kubernetes into tf

