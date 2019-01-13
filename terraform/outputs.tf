output "instrumentation_key" {
  value = "${azurerm_application_insights.ai.instrumentation_key}"
}

output "cosmos_endpoint" {
  value = "${azurerm_cosmosdb_account.db.endpoint}"
}

output "cosmos_primary_master_key" {
  value = "${azurerm_cosmosdb_account.db.primary_master_key}"
}

output "cosmos_primary_readonly_master_key" {
  value = "${azurerm_cosmosdb_account.db.primary_readonly_master_key}"
}
