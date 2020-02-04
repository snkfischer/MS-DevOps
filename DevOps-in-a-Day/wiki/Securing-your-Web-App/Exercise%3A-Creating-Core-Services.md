# Exercise: Creating Core Services

Let's get on with creating our modules! 

The first module we are going to create is for the Virtual Network and Subnets. This module will be called `core_services`. Normally, we would separate networking resources into it's own Resource Group, but for the purposes of this workshop, we're going to use a single resource group.

> **Why a new Resource Group?**
>
> We like to create networking resources in their own resource group to better control who has read/write access to them. Often times, we find customers have dedicated networking teams that manage networking resources.

Start by creating a folder in `terraform\_modules` called `core_services`. Next, create the three standard Terraform files: 
- main.tf
- variables.tf
- output.tf

Open the `core_services\variables.tf` file and paste the following code:

```
variable "functional_name" {
    description = "The primary purpose of the resources (ex. 'shared-services')"
}

variable "location" {
    description = "Location where Resources will be deployed"
}

variable "virtual_network_address_space" {
    description = "The Address Space of the Virtual Network"
}

variable "management_subnet" {
    description = "The Management Subnet (x.x.x.x/x)"
}

variable "gateway_subnet" {
    description = "The Gateway Subnet (x.x.x.x/x)"
}

variable "application_name" {
    description = "The Name of the Application"
}

variable "environment" {
    description = "Environment of all deployed resources"
}

variable "resource_group_name" {
    description = "Resource group name to deploy resources"
}
```

Nothing too new here, this just establishes the variables we plan to use for the module. Notice the `management_subnet` and `gateway_subnet` variables. This will allow users to pass in a CIDR address space (ex. 10.10.0.0/16) to define a subnet. There are ways to dynamically generate subnets using built-in Terraform functions, but we won't be diving into that in this workshop. Ask us about it if you're interested.

Next, let's populate our main.tf file with resources. Copy and paste the following code into your `core_services\main.tf` file:

```
# Virtual Network
resource "azurerm_virtual_network" "core_vnet" {
    name                = "tf-az-${var.functional_name}-${var.environment}-vnet"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    address_space       = ["${var.virtual_network_address_space}"]
}

# Subnets
resource "azurerm_subnet" "management_subnet" {
    name                 = "tf-az-${var.functional_name}-mgmt-subnet"
    address_prefix       = "${var.management_subnet}"
    virtual_network_name = "${azurerm_virtual_network.core_vnet.name}"
    resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_subnet" "gateway_subnet" {
    name                 = "tf-az-${var.functional_name}-gw-subnet"
    address_prefix       = "${var.gateway_subnet}"
    virtual_network_name = "${azurerm_virtual_network.core_vnet.name}"
    resource_group_name = "${var.resource_group_name}"
}
```

We have created a new Resource Group, a Virtual Network, and two Subnets. Take note of the `address_space` parameter in the virtual network resource. The [] are required because the `address_space` parameter expects a list. Lists are declared with [] in Terraform. This means we could pass in more than one comma-separated address space if we wanted.

> **Why two subnets?**
>
> When deploying network resources, we like to provision a management subnet and a subnet for the resource.  The management subnet is a standard subnet generally used for operations resources, like a VM to test configuration. The gateway subnet will be used for the App Gateway. This is purely a preference, but we've found it helps ease management in emergencies, or during troubleshooting.

We are almost done with this module. We need to add an output. Open the `core_services\output.tf` file and paste the following code:

```
output "gateway_subnet_id" {
   value = "${azurerm_subnet.gateway_subnet.id}"
}
```

This output will be used to pass the gateway subnet id from this module to the next module we will create. We are doing this because the next module includes our Application Gateway, and one of the required parameters is the subnet id for gateway configuration.

## The Shared Services

The next module we will create is the shared services module. This is where our App Gateway resides and is theoretically the place where all services which are shared between multiple applications should reside. Or rather, services which have a shared level of management between teams. Arguably we could have App Service Plans and SQL Server resources here since they could be shared between multiple applications but we prefer to keep these co-located with the applications they support, as they will generally be managed by the same teams.

Create a folder under `_modules` called `shared_services` and create the three Terraform files:
- main.tf
- variables.tf
- output.tf

Open the `shared_services\variables.tf` file and paste the following code:

```
variable "functional_name" {
    description = "The primary purpose of the resources (ex. 'shared-services')"
}

variable "location" {
    description = "Location where Resources will be deployed"
}

variable "gateway_subnet_id" {
    description = "The Gateway Subnet (x.x.x.x/x)"
}

variable "application_name" {
    description = "The Name of the Application"
}

variable "environment" {
    description = "Environment of all deployed resources"
}

variable "app_service_fqdn" {
    description = "The FQDN of the Application Service"
}

variable "resource_group_name" {
    description = "Resource group name to deploy resources"
}
```

The `gateway_subnet_id` and the `app_service_fqdn` variables from above will be populated with the outputs from the `core_services` and `standard_application` modules. Way back in chapter three we created an output in our `standard_application` module called `app_service_fqdn` which retrieves the App Service FQDN for use with our Application Gateway. Likewise, the `gateway_subnet_id` will be passed from the output we created earlier in this chapter for use in the App Gateway resource. We'll talk more about how we pass in those outputs later.

Let's populate our `shared_services\main.tf` file with all the resources we need:

```
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
```

As you can see from the above code, the App Gateway is a fairly complicated resource. The first four sub-property blocks create the core components of the Application Gateway: `sku`, `gateway_ip_configuration`, `frontend_port`, `frontend_ip_configuration`. 

The next four sub-property blocks are tied to specific application pools (in our case, the single web application): `backend_address_pool`, `backend_http_settings`, `http_listener`, `request_routing_rule`. 

If we had multiple application back-ends (or apps) this App Gateway talked to, we would need to include those four sub-property blocks AGAIN for that application. This means the App Gateway resource can grow in a configuration file and is the primary reason we have split this resource out into its own module.

Notice the `gateway_ip_configuration` includes our `gateway_subnet_id` variable which will be populated with our output from the `core_services` module. The `backend_address_pool` includes our `app_service_fqdn` variable which will be populated with our output from the `standard_application` module.

We are not going to add any outputs in the `shared_services` module but we want the file to exist so that if we later decide we need information from this module we can update the module to include those outputs.

_This concludes the exercise._
