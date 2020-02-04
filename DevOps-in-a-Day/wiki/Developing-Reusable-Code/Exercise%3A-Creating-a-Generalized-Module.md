# Creating a Generalized Module

Now that you know what goes into a module, let's build one together.

Before we begin, clean up your repos `terraform` folder by removing the following files/folders (use VS Code to delete):
- .terraform folder
- terraform.tfstate file
- terraform.tfstate.backup file (if it exists)

Create a new folder in your `terraform` folder. We are going to call this folder `_modules`. 

Next, create a sub-folder in `_modules` called `standard_application`. 

Now move the `main.tf` file we created in the previous chapter into this folder. In VS Code, drag the file from it's current parent location to the `standard_application` sub-folder you just created.

Next, create two more files in the `standard_application` folder. Create an empty `variables.tf` file and an empty `output.tf` file. We'll populate these later as we get a better feel for what variables we need.

This creates the baseline of our module, but we aren't done. 

We are going to create two more folders at the root of `terraform`. First create a folder called `dev`, then a folder called `prod`. We'll work with these folders more toward the end of this section.

## Generalizing the Module

Technically the `main.tf` file we created earlier is part of a module now called `standard_application` but we cannot re-use it yet. There are certain parameters we have hard-coded which will prevent us from dynamically calling the module. Let's change that by replacing those hard-coded values with variables.

> **Before we go further**
>
> Please remove the provider block at the top of the `main.tf` file we created earlier. Save the provider code (you can paste it into notepad for now) -- we'll need it later. We'll talk about why you have to do this later. 

Open up the `variables.tf` file and paste the following code:

```
variable "location" {
    description = "Location where Resources will be deployed"
}

variable "application_plan_tier" {
    description = "Tier of the Application Plan (Free, Shared, Basic, Standard, Premium, Isolated)"
}

variable "application_plan_size" {
    description = "Instance Size of the Application Plan (F1, D1, B1, B2, B3, S1, S2, S3, P1v2, P2v2, P3v2, PC2, PC3, PC4, I1, I2, I3)"
}

variable "application_name" {
    description = "Name of the Application"
}

variable "environment" {
    description = "Environment of all deployed resources"
}
```

>**More on variables**
>
> We like to think of modules like an API. The variables represent input values that allow the module to be flexible and provision different infrastructure configurations - they form the API's surface and interface. The module's `main.tf` code then represents the implementation of the API. 

With our freshly declared variables, let's open up the `output.tf` file and paste the following:

```
output "app_service_fqdn" {
    value = "${azurerm_app_service.app1_app_service.default_site_hostname}"
}

output "resource_group_name" {
    value = "${azurerm_resource_group.application_rg.name}"
}
```

We will be using this output in a future chapter, and will discuss this in more detail at that time.

Let's move on to the `main.tf` file and begin generalizing the resources we previously created.

Replace the existing Resource Group block with the following code:

```
# Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "az-workshop-userXXX-rg" # replace XXX with your user number!!!
    location = "${var.location}"
}
```

Variables are called by supplying `${var.<variable name>}`. You'll also notice that you can place variables side-by-side in Terraform code (like we did with the *name* key/value pair above).

Next, let's generalize the App Service Plan and App Service:

```
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
```

_This concludes the exercise._
