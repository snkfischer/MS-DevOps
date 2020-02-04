# Exercise: Declaring Resources

Now that we have established the Provider, we can begin declaring resources. Resources are always declared in the same way. We start with what resource we want to deploy, the alias name for the resource, and the parameters required to deploy the resource.

For example:

```
resource "azurerm_resource_group" "my_resource_alias" {
  # key-value parameter pairs go here
  key1 = value1
  key2 = value2
}
```

Let's start by declaring an Azure resource group. 

> **Resource Groups** 
>
> Formally, resource groups provide a way to monitor, control access, provision and manage billing for collections of assets that are required to run an application, or used by a client or company department. Informally, think of resource groups like a file system folder, but instead of holding files and other folders, resource groups hold azure objects like storage accounts, web apps, functions, etc.

Copy and paste the below section to create a new resource group:

```
# Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "az-workshop-userXXX-rg" # replace XXX with your user number!!!
    location = "East US"
}
```

Don't forget to replace XXX with your user number. If you forget you won't be able to 

This resource only requires two parameters: a name and location. 

> **Aren't there more parameters?**
>
> If you're familiar with Azure, you may be thinking there are a bunch of other optional parameters you could provide for a resource group. You're right. There are additional parameters which are accepted by Terraform if we wanted to configure aspects like resource tags, etc. For this workshop you'll be filling in required parameters only. If you want to see the full list of parameters available for a resource, click on the highlighted resource name `azurerm_resource_group` in your VS Code `main.tf` file, or check out the options [here](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html). 

> **What's in the Azure RM Provider?**
>
> There are a ton of resources you can declare using the AzureRM resource provider - too many to review here. Take a look at the [online documentation](https://www.terraform.io/docs/providers/azurerm/index.html) to see a comprehensive list. You'll also be able to see required and optional parameters for each resource type.

## Declaring an App Service Plan

Next, we are going to add the App Service Plan. Add the following code below the resource group resource in `main.tf`:

```
resource "azurerm_app_service_plan" "standard_app_plan" {
    name = "tf-standard-plan"
    location = "${azurerm_resource_group.application_rg.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    sku {
        tier = "Basic"
        size = "B1"
    }
}
```

When parameters of a resource have multiple/sub-parameters, they are encapsulated with {}. If you're familiar with JSON, this shouldn't look too strange. In this case, the App Service Plan has a multi-property parameter for the sku tier and sku size.

> **Whoa...dot-notation in Terraform?!**
>
> You may have noticed the ${} syntax with resource names and dot-notation in the above syntax. If you're familiar with programming languages, this won't surprise you. Terraform allows you to reference other declared resources by wrapping them in ${}, and using dot-notation to drill into properties of that resource. This comes in handy when you're chaining resources together, or when one resource depends on another resource. 
 
Looking back at the App Service Plan you just created, notice the "location" and "resource_group_name" properties. We used the dot-notation to obtain their values. We can pull other properties from other declared resources using the syntax `azurerm_<resource_type>.<resource_alias>`. In this case the resource type is `resource_group`, the resource alias is `application_rg` (we provided the resource alias in the previous code snippet next to the declaration of the resource type), and the property we care about for location is `.location` and for resource_group_name it's `.name`.

Now that we have declared the Plan our Application Service will use, let's create the Azure Web App. Use the following code and add it to your `main.tf` file:

```
# Random Integer for App Service
resource "random_integer" "ri" {
    min = 10000
    max = 99999
}

resource "azurerm_app_service" "app1_app_service" {
    name = "tf-az-app1-dev-app${random_integer.ri.result}"
    location = "East US"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.standard_app_plan.id}"
}
```

> **A few words on naming conventions**
>
> The standard naming convention in Terraform is to keep everything lowercase and separate key words by dashes. In addition to Terraform's standards, we have established here a pattern for naming resources in Azure. This pattern is a common best practice for Azure and can vary for each organization based on naming needs. The pattern above is as follows: `tf` to declare the resource was created by Terraform, `az` to denote this is an Azure resource (this comes in handy when in a hybrid scenario), `app1` is the application name, `dev` is the environment, and `app` is the shorthand chosen for the resource type. 

> **WARNING: Watch out for platform limitations when naming resources**
>
> In some cases, you cannot use dashes in names of Azure resources (ex. Storage Account) so an alternative is to keep everything lowercase and have no separation of key words with dashes if you want to keep names uniform across the board.
>
> Some resources must also have globally unique names (like Storage Accounts...again), so you may need adjust names accordingly. 

You may have noticed the random integer code block above - that's present to ensure you have a globally unique app service.

_This concludes the exercise._
