output "instrumentation_key" {
  value = "${azurerm_application_insights.ai.instrumentation_key}"
}

output "storage_connection_string" {
  value = "${azurerm_storage_account.sa.primary_connection_string}"
}
