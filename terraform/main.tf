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

resource "azurerm_storage_account" "sa" {
  name                     = "${var.sa_name}"
  location                 = "${azurerm_resource_group.rg.location}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
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

resource "azurerm_container_group" "taskboard_queries" {
  name                = "taskboard-queries"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ip_address_type     = "public"
  os_type             = "Linux"
  dns_name_label      = "taskboard-queries"

  container {
    name   = "taskboard-queries"
    image  = "scottrangerio.azurecr.io/taskboard-queries:0.2"
    cpu    = "0.5"
    memory = "1"
    port   = "80"

    environment_variables {
      "AI_INSTRUMENTATIONKEY" = "${azurerm_application_insights.ai.instrumentation_key}"
      "COSMOS_ENDPOINT"       = "${azurerm_cosmosdb_account.db.endpoint}"
      "COSMOS_KEY"            = "${azurerm_cosmosdb_account.db.primary_readonly_master_key}"
      "COSMOS_DB"             = "Taskboard"
      "COSMOS_COLLECTION"     = "List"
    }
  }

  image_registry_credential {
    username = "${var.registry_username}"
    password = "${var.registry_password}"
    server   = "${var.registry_server}"
  }
}

resource "azurerm_container_group" "taskboard_commands" {
  name                = "taskboard-commands"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ip_address_type     = "public"
  os_type             = "Linux"
  dns_name_label      = "taskboard-commands"

  container {
    name   = "taskboard-commands"
    image  = "scottrangerio.azurecr.io/taskboard-commands:0.2"
    cpu    = "0.5"
    memory = "1"
    port   = "80"

    environment_variables {
      "AI_INSTRUMENTATIONKEY" = "${azurerm_application_insights.ai.instrumentation_key}"
      "COSMOS_ENDPOINT"       = "${azurerm_cosmosdb_account.db.endpoint}"
      "COSMOS_KEY"            = "${azurerm_cosmosdb_account.db.primary_master_key}"
      "COSMOS_DB"             = "Taskboard"
      "COSMOS_COLLECTION"     = "List"
      "LIST_RESOURCE_URI"     = "${var.apim_base}/list/{0}"
    }
  }

  image_registry_credential {
    username = "${var.registry_username}"
    password = "${var.registry_password}"
    server   = "${var.registry_server}"
  }
}
