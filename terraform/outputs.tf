output "instrumentation_key" {
  value = "${azurerm_application_insights.ai.instrumentation_key}"
}

output "storage_connection_string" {
  value = "${azurerm_storage_account.sa.primary_connection_string}"
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

output "taskboard_queries_ip_address" {
  value = "${azurerm_container_group.taskboard_queries.ip_address}"
}

output "taskboard_commands_ip_address" {
  value = "${azurerm_container_group.taskboard_commands.ip_address}"
}

output "taskboard_queries_fqdn" {
  value = "${azurerm_container_group.taskboard_queries.fqdn}"
}

output "taskboard_commands_fqdn" {
  value = "${azurerm_container_group.taskboard_commands.fqdn}"
}
