terraform {
  backend "azurerm" { }
}

provider "azurerm" {
    tenant_id       = "c955ad27-2aec-4e59-b9fe-cdea2695e82e"
    subscription_id = "1aac80b7-c45c-411b-9d6b-190224f8a013"
    skip_provider_registration = true
    client_id       = "b7429b36-5c11-42ce-8609-1f1060be7019"
    client_secret   = "52d8ed06-e82c-48cc-9207-09224e5f6f0e"
}

module "standard_application" {
    source                     = "../_modules/standard_application/"
    environment                = "prod"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
    sql_administrator_login    = "sqladmin"
    sql_administrator_password = "SQLP@ss123"
}
module "core_services" {
    source                        = "../_modules/core_services/"
    environment                   = "prod"
    functional_name               = "core-services"
    location                      = "East US"
    virtual_network_address_space = "10.10.0.0/16"
    management_subnet             = "10.10.1.0/24" 
    gateway_subnet                = "10.10.2.0/24"
    application_name              = "app1"
    resource_group_name           = "${module.standard_application.resource_group_name}"    
}
module "shared_services" {
    source              = "../_modules/shared_services/"
    environment         = "prod"
    functional_name     = "shared-services"
    location            = "East US"
    application_name    = "app1"
    gateway_subnet_id   = "${module.core_services.gateway_subnet_id}"
    app_service_fqdn    = "${module.standard_application.app_service_fqdn}"
    resource_group_name = "${module.standard_application.resource_group_name}"    
}  