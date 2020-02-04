# Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "az-workshop-user26-rg" # replace XXX with your user number!!!
    location = "${var.location}"
}

# App Service Plan
resource "azurerm_app_service_plan" "standard_app_plan" {
    name                = "tf-az-standard-${var.environment}-plan"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    sku {
        tier = "${var.application_plan_tier}"
        size = "${var.application_plan_size}"
    }
}

# Random Integer for Unique Names
resource "random_integer" "ri" {
    min = 10000
    max = 99999
}

# App Service
resource "azurerm_app_service" "app1_app_service" {
    name                = "tf-az-${var.application_name}-${var.environment}-app${random_integer.ri.result}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.standard_app_plan.id}"
}

resource "azurerm_sql_server" "standard_sql_server" {
  name                         = "tf-az-standard-sql-${var.environment}-${random_integer.ri.result}"
  resource_group_name          = "${azurerm_resource_group.application_rg.name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sql_administrator_login}"
  administrator_login_password = "${var.sql_administrator_password}"
}

resource "azurerm_sql_database" "app1_db" {
  name                = "tf-az-${var.application_name}-${var.environment}-db"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
}

resource "azurerm_sql_firewall_rule" "test" {
  name                = "tf-az-${var.application_name}-${var.environment}-allow-azure-sqlfw${random_integer.ri.result}"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
  start_ip_address    = "0.0.0.0" # tells Azure to allow Azure services
  end_ip_address      = "0.0.0.0" # tells Azure to allow Azure serivces
}

# Application Insights
resource "azurerm_application_insights" "ai" {
  name                = "tf-az-${var.application_name}-${var.environment}-appinsights"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  application_type    = "web"
}