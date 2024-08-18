// Terraform\output.tf
output "web_app_url" {
  value = azurerm_linux_web_app.alwa.default_hostname
}

output "webapp_ip_addresses" {
  value = azurerm_linux_web_app.alwa.outbound_ip_addresses
}
