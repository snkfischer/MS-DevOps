output "app_service_fqdn" {
    value = "${azurerm_app_service.app1_app_service.default_site_hostname}"
}

output "resource_group_name" {
    value = "${azurerm_resource_group.application_rg.name}"
}