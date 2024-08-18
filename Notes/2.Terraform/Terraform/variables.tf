// Terraform\variables.tf
variable "resource_group" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "app_service_plan" {
  type        = string
  description = "The name of the app service plan"
}

variable "app_service_name" {
  type        = string
  description = "The name of the app service"
}

variable "sql_server_name" {
  type        = string
  description = "The name of the sql server"
}

variable "database" {
  type        = string
  description = "The name of the database"
}

variable "sql_admin" {
  type        = string
  description = "sql user"
}

variable "sql_user_pass" {
  type        = string
  description = "sql user pass"
}

variable "firewall" {
  type        = string
  description = "The name of the firewall"
}

variable "github_repo" {
  type        = string
  description = "The name of the github repo"
}
