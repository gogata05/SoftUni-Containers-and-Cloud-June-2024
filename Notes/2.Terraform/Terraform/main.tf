// Terraform\main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.115.0" // Copy the azurerm latest version from https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
    }
  }
}

provider "azurerm" {
  features {}
}

//Resource Group - azurerm_resource_group
resource "azurerm_resource_group" "arg" {
  name     = var.resource_group
  location = var.location
}

//Service Plan - azurerm_service_plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

//Linux Web App - azurerm_linux_web_app
resource "azurerm_linux_web_app" "alwa" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  service_plan_id     = azurerm_service_plan.asp.id
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldatabase.name} ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
  site_config {
    application_stack {
      dotnet_version = "6.0"
    } //change .NET Version
    always_on = false
  }
}

//sql server - azurerm_mssql_server
resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_user_pass
}

//sql server database - azurerm_mssql_database
resource "azurerm_mssql_database" "sqldatabase" {
  name         = var.database
  server_id    = azurerm_mssql_server.sqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
}

//firewall - azurerm_mssql_firewall_rule
resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.firewall
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

//repository - azurerm_app_service_source_control
resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = var.github_repo
  branch                 = "main"
  use_manual_integration = true
}