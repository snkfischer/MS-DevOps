# Resource Group
# Public IP Address
resource "azurerm_public_ip" "gateway_pip" {
    name                = "tf-az-${var.functional_name}-${var.environment}-pip"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.location}"
    sku                 = "Standard"
    allocation_method   = "Static"
}

# App Gateway
resource "azurerm_application_gateway" "gateway" {
    name                = "tf-az-${var.functional_name}-${var.environment}-ag"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
 
    sku {
        name        = "WAF_v2"
        tier        = "WAF_v2"
        capacity    = 1
    }
 
    gateway_ip_configuration {
        name        = "tf-az-${var.functional_name}-ip-configuration"
        subnet_id   = "${var.gateway_subnet_id}"
    }

    frontend_port {
        name = "tf-az-${var.functional_name}-fep-80"
        port = 80
    }
    
    frontend_ip_configuration {
        name                    = "tf-az-${var.functional_name}-feip"
        public_ip_address_id    = "${azurerm_public_ip.gateway_pip.id}"
    }

    backend_address_pool {
        name    = "tf-az-${var.application_name}-beap"
        fqdns   = ["${var.app_service_fqdn}"]
    }
 
    backend_http_settings {
        name                                = "tf-az-${var.application_name}-http-80"
        cookie_based_affinity               = "Disabled"
        path                                = "/"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 20
        pick_host_name_from_backend_address = true 
    }
 
    http_listener {
        name                            = "tf-az-${var.application_name}-listener"
        frontend_ip_configuration_name  = "tf-az-${var.functional_name}-feip"
        frontend_port_name              = "tf-az-${var.functional_name}-fep-80"
        protocol                        = "Http"
    }
 
    request_routing_rule {
        name                        = "tf-az-${var.application_name}-rule"
        rule_type                   = "Basic"
        http_listener_name =        "tf-az-${var.application_name}-listener"
        backend_address_pool_name   = "tf-az-${var.application_name}-beap"
        backend_http_settings_name  = "tf-az-${var.application_name}-http-80"
    }
}